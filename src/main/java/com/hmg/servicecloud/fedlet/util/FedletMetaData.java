package com.hmg.servicecloud.fedlet.util;

import com.sun.identity.saml2.jaxb.metadata.AssertionConsumerServiceElement;
import com.sun.identity.saml2.jaxb.metadata.IDPSSODescriptorElement;
import com.sun.identity.saml2.jaxb.metadata.SPSSODescriptorElement;
import com.sun.identity.saml2.jaxb.metadata.SingleSignOnServiceElement;
import com.sun.identity.saml2.meta.SAML2MetaException;
import com.sun.identity.saml2.meta.SAML2MetaManager;

import javax.servlet.ServletContext;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

/**
 * @author Andreas Vallen
 */
public class FedletMetaData {

    private String spEntityId;
    private String spMetaAlias;
    private String spBaseUrl;
    private String idpEntityId;
    private String idpMetaAlias;
    private String idpBaseUrl;
    public static SAML2MetaManager saml2MetaManager;

    static {
        try {
            saml2MetaManager = new SAML2MetaManager();
        } catch (SAML2MetaException e) {
            e.printStackTrace();
        }
    }

    private FedletMetaData(String spEntityId, String spMetaAlias, String spBaseUrl, String idpEntityId, String idpMetaAlias, String idpBaseUrl) throws SAML2MetaException {
        this.spEntityId = spEntityId;
        this.spMetaAlias = spMetaAlias;
        this.spBaseUrl = spBaseUrl;
        this.idpEntityId = idpEntityId;
        this.idpMetaAlias = idpMetaAlias;
        this.idpBaseUrl = idpBaseUrl;
    }

    public static synchronized FedletMetaData createFromMetaData(ServletContext context) throws SAML2MetaException {

        String spEntityId, spMetaAlias;

        List<String> spEntities =
                saml2MetaManager.getAllHostedServiceProviderEntities("/");
        if ((spEntities == null) || spEntities.isEmpty()) {
            throw new SAML2MetaException("No configured Serivce Provider Entities found.");
        }
        // get first one
        spEntityId = spEntities.get(0);

        List spMetaAliases =
                saml2MetaManager.getAllHostedServiceProviderMetaAliases("/");
        if ((spMetaAliases == null) || spMetaAliases.isEmpty()) {
            throw new SAML2MetaException("no configured SP MetaAliases found.");
        }
        // get first one
        spMetaAlias = (String) spMetaAliases.get(0);

        String idpEntityId = getConfiguredIDPEntityID(spEntityId);

        String idpMetaAlias = parseIDPAliasFromMetadata(idpEntityId);
        String idpBaseUrl = parseIDPBaseURLFromMetadata(idpEntityId);
        String spBaseUrl = parseSPBaseURLFromMetadata(spEntityId, context.getContextPath());

        return new FedletMetaData(spEntityId, spMetaAlias, spBaseUrl, idpEntityId, idpMetaAlias, idpBaseUrl);
    }

    private static String getConfiguredIDPEntityID(String spEntityId) throws SAML2MetaException {
        List<String> idpEntityIDs = saml2MetaManager.getAllRemoteIdentityProviderEntities("/");

        if (idpEntityIDs == null) {
            throw new SAML2MetaException("Cannot find a configured remote identity provider.");
        }
        if (idpEntityIDs.size() != 1) {
            throw new SAML2MetaException("more than one identity provider is configured in metadata.");
        }

        String idpEntityID = idpEntityIDs.get(0);
        if (!saml2MetaManager.isTrustedProvider("/", spEntityId, idpEntityID)) {
            throw new SAML2MetaException("The configured identity provider is not trusted.");
        }
        return idpEntityID;
    }


    private static String parseSPBaseURLFromMetadata(String spEntityId, String contextPath) throws SAML2MetaException {
        SPSSODescriptorElement sp =
                saml2MetaManager.getSPSSODescriptor("/", spEntityId);
        List acsList = sp.getAssertionConsumerService();
        if ((acsList == null) || (acsList.isEmpty())) {
            throw new SAML2MetaException("Missing assertionconsumerservice URL in Service Provider metadata.");
        }
        Iterator j = acsList.iterator();
        while (j.hasNext()) {
            AssertionConsumerServiceElement acs =
                    (AssertionConsumerServiceElement) j.next();
            if ((acs != null) && (acs.getBinding() != null)) {
                String acsURL = acs.getLocation();
                int loc = acsURL.indexOf(contextPath + "/");
                if (loc == -1) {
                    continue;
                } else {
                    return acsURL.substring(
                            0, loc + contextPath.length());
                }
            }
        }
        throw new SAML2MetaException("Unable to parse the SP base URL from the AssertionConsumerServiceURL");
    }

    /**
     * Derives the OpenSSO-specific "metaAlias" from the IDP Metadata configuration (the one in idp.xml).
     * <p/>
     * It does so by parsing the URLs of the configured SingleSignOnService entries, which look like so:
     * <p/>
     * http://test-sso.lexware.de:8080/auth/IDPSloRedirect/metaAlias/idp
     * <p/>
     * where the metaAlias is "idp"
     * and the baseURL is "http://test-sso.lexware.de:8080/auth"
     *
     * @param idpEntityID
     * @return
     * @throws com.sun.identity.saml2.meta.SAML2MetaException
     *
     */
    private static String parseIDPAliasFromMetadata(String idpEntityID) throws SAML2MetaException {
        List<String> ssoServiceURLs = getSSOServiceURLs(idpEntityID);
        for (String ssoURL : ssoServiceURLs) {
            int metaAliasIndex = ssoURL.indexOf("/metaAlias/");
            if (metaAliasIndex == -1) {
                continue;
            } else {
                return ssoURL.substring(metaAliasIndex + 10);
            }
        }
        throw new SAML2MetaException("Could not parse metaAlias from SAML metadata for IDP entity ID " + idpEntityID);
    }

    private static String parseIDPBaseURLFromMetadata(String idpEntityID) throws SAML2MetaException {
        List<String> ssoServiceURLs = getSSOServiceURLs(idpEntityID);
        for (String ssoURL : ssoServiceURLs) {
            int loc = ssoURL.indexOf("/metaAlias/");
            if (loc == -1) {
                continue;
            } else {
                String ssoUrlWithoutMetaAlias = ssoURL.substring(0, loc);
                loc = ssoUrlWithoutMetaAlias.lastIndexOf("/");
                return ssoUrlWithoutMetaAlias.substring(0, loc);
            }
        }
        throw new SAML2MetaException("Could not parse metaAlias from SAML metadata for IDP entity ID " + idpEntityID);
    }

    private static List<String> getSSOServiceURLs(String idpEntityID) throws SAML2MetaException {
        IDPSSODescriptorElement idp =
                saml2MetaManager.getIDPSSODescriptor("/", idpEntityID);
        List ssoServiceList = idp.getSingleSignOnService();
        if ((ssoServiceList != null)
                && (!ssoServiceList.isEmpty())) {
            List<String> ssoServiceURLs = new ArrayList<String>();
            Iterator ssoServiceElements = ssoServiceList.iterator();
            while (ssoServiceElements.hasNext()) {
                SingleSignOnServiceElement sso =
                        (SingleSignOnServiceElement) ssoServiceElements.next();
                if ((sso != null) && (sso.getBinding() != null)) {
                    String ssoURL = sso.getLocation();
                    ssoServiceURLs.add(ssoURL);
                }
            }
            return ssoServiceURLs;
        }
        return Collections.emptyList();
    }


    public String getSpEntityId() {
        return spEntityId;
    }

    public String getSpMetaAlias() {
        return spMetaAlias;
    }

    public String getSpBaseUrl() {
        return spBaseUrl;
    }

    public String getIdpEntityId() {
        return idpEntityId;
    }

    public String getIdpMetaAlias() {
        return idpMetaAlias;
    }

    public String getIdpBaseUrl() {
        return idpBaseUrl;
    }
}

