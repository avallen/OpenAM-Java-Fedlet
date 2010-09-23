package com.hmg.servicecloud.fedlet.servlet;

import com.sun.identity.saml.common.SAMLUtils;
import com.sun.identity.saml2.meta.SAML2MetaManager;
import com.sun.identity.saml2.meta.SAML2MetaUtils;
import org.owasp.esapi.ESAPI;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Exports the SAML metadata of this Service Provider, for retrieval by IDPs
 * for example.
 * <p/>
 * This is an optional feature that facilitates setup of a Circle of trust at the
 * cost of information exposure.
 * <p/>
 * This is a servlet implementation of the code that in the original fedlet is
 * realized in the JSP exportmetadata.jsp.
 *
 */
public class ExportMetadataServlet extends javax.servlet.http.HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // This JSP is used to export standard entity metadata,
        // there are three supported query parameters:
        //    * role     -- role of the entity: sp, idp or any
        //    * realm    -- realm of the entity
        //    * entityid -- ID of the entity to be exported
        //    * sign     -- sign the metadata if the value is "true"
        // If none of the query parameter is specified, it will try to export
        // the first hosted SP metadata under root realm. If there is no hosted
        // SP under the root realm, the first hosted IDP under root realm will
        // be exported. If there is no hosted SP or IDP, an error message will
        // be displayed.
        String metaXML = null;
        String errorMsg = null;
        try {
            SAMLUtils.checkHTTPContentLength(request);
            String role = request.getParameter("role");
            if ((role == null) || (role.length() == 0)) {
                // default role is any if not specified
                role = "any";
            }
            String realm = request.getParameter("realm");
            if ((realm == null) || (realm.length() == 0)) {
                // default to root realm
                realm = "/";
            }
            String entityID = request.getParameter("entityid");
            boolean sign = "true".equalsIgnoreCase(request.getParameter("sign"));
            SAML2MetaManager manager = new SAML2MetaManager();
            if ((entityID == null) || (entityID.length() == 0)) {
                // find first available one
                List providers;
                if ("sp".equals(role)) {
                    providers = manager.
                            getAllHostedServiceProviderEntities(realm);
                } else if ("idp".equals(role)) {
                    providers = manager.
                            getAllHostedIdentityProviderEntities(realm);
                } else {
                    // will return any role
                    // try SP first
                    providers = manager.
                            getAllHostedServiceProviderEntities(realm);
                    if ((providers == null) || providers.isEmpty()) {
                        providers = manager.
                                getAllHostedIdentityProviderEntities(realm);
                    }
                }
                if ((providers != null) && !providers.isEmpty()) {
                    entityID = (String) providers.iterator().next();
                }
            }

            if ((entityID == null) || (entityID.length() == 0)) {
                errorMsg = "No matching entity metadata found.";
            } else {
                metaXML = SAML2MetaUtils.exportStandardMeta(realm, entityID,
                        sign);
                if (metaXML == null) {
                    errorMsg = "No metadata for entity \""
                            + ESAPI.encoder().encodeForHTML(entityID)
                            + "\" under realm \""
                            + ESAPI.encoder().encodeForHTML(realm)
                            + "\" found.";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMsg = e.getMessage();
        }
        if (errorMsg != null) {
            response.getWriter().println("ERROR:" + errorMsg);
        } else {
            response.setContentType("text/xml");
            response.setHeader("Pragma", "no-cache");
            response.setContentType("text/xml; charset=utf-8");
            response.getWriter().print(metaXML);
        }
    }
}
