package com.hmg.servicecloud.fedlet.saml;

import com.hmg.servicecloud.fedlet.util.FedletConfiguration;
import com.sun.identity.saml2.common.SAML2Exception;
import com.sun.identity.saml2.common.SAML2Utils;
import com.sun.identity.saml2.profile.SPSSOFederate;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.logging.Logger;

import static com.sun.identity.saml2.common.SAML2Constants.*;


/**
 * Following are the list of supported request parameters:
 * <p/>
 * Query Parameter Name    Description
 * <p/>
 * 1. metaAlias         MetaAlias for Service Provider. The format of
 * this parameter is /realm_name/SP name. If unspecified,
 * first available hosted SP is used.
 * <p/>
 * 2. idpEntityID       Identifier for Identity Provider. If unspecified,
 * first available remote IDP is used.
 * <p/>
 * 3. RelayState        Target URL on successful complete of SSO/Federation
 * <p/>
 * 4. RelayStateAlias   Specify the parameter(s) to use as the RelayState.
 * e.g. if the request URL has :
 * ?TARGET=http://server:port/uri&RelayStateAlias=TARGET
 * then the TARGET query parameter will be interpreted as
 * RelayState and on successful completion of
 * SSO/Federation user will be redirected to the TARGET
 * URL.
 * <p/>
 * 5. NameIDFormat      NameIDPolicy format Identifier Value.
 * For example,
 * urn:oasis:names:tc:SAML:2.0:nameid-format:persistent
 * urn:oasis:names:tc:SAML:2.0:nameid-format:transient
 * Note : transient will always be used for Fedlet
 * <p/>
 * 6. binding           URI value that identifies a SAML protocol binding to
 * used when returning the Response message.
 * The supported values are :
 * HTTP-Artifact
 * HTTP-POST (default for Fedlet)
 * <p/>
 * 7. AssertionConsumerServiceIndex
 * An integer number indicating the location
 * to which the Response message should be returned to
 * the requester.
 * <p/>
 * 8. AttributeConsumingServiceIndex
 * Indirectly specifies information associated
 * with the requester describing the SAML attributes
 * the requester desires or requires to be supplied
 * by the IDP in the generated Response message.
 * Note: This parameter may not be supported for
 * this release.
 * <p/>
 * 9. isPassive         true or false value indicating whether the IDP
 * should authenticate passively.
 * <p/>
 * 10. ForceAuthN       true or false value indicating if IDP must
 * force authentication OR false if IDP can rely on
 * reusing existing security contexts.
 * true - force authentication
 * <p/>
 * 11.AllowCreate       Value indicates if IDP is allowed to created a new
 * identifier for the principal if it does not exist.
 * Value of this parameter can be true OR false.
 * true - IDP can dynamically create user.
 * <p/>
 * 12.Destination       A URI Reference indicating the address to which the
 * request has been sent.
 * <p/>
 * 13.AuthnContextDeclRef
 * Specifies the AuthnContext Declaration Reference.
 * The value is a pipe separated value with multiple
 * references.
 * <p/>
 * 14.AuthnContextClassRef
 * Specifies the AuthnContext Class References.
 * The value is a pipe separated value with multiple
 * references.
 * <p/>
 * 15 AuthLevel         The Authentication Level of the Authentication
 * Context to use for Authentication.
 * <p/>
 * 16.AuthComparison    The comparison method used to evaluate the
 * requested context classes or statements.
 * Allowed values are :
 * exact
 * minimum
 * maximum
 * better
 * <p/>
 * 17.Consent           Specifies a URI a SAML defined identifier
 * known as Consent Identifiers.These are defined in
 * the SAML 2 Assertions and Protocols Document.
 * Note: This parameter may not be supported for
 * this release.
 * <p/>
 * 18.reqBinding        URI value that identifies a SAML protocol binding to
 * used when sending the AuthnRequest.
 * The supported values are :
 * urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect
 * urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST
 * <p/>
 * 19.affiliationID     Affiliation entity ID
 */
public class AuthenticationRequestSender {

    private Logger logger = Logger.getLogger(this.getClass().getName());

    private FedletConfiguration fedletConfiguration;
    private HashMap<String, List<String>> configuredParamsMap;

    public AuthenticationRequestSender(FedletConfiguration fedletConfiguration, Map<String,List<String>> paramMap) {
        this(fedletConfiguration);
        this.configuredParamsMap.putAll(paramMap);
    }

    public AuthenticationRequestSender(FedletConfiguration fedletConfiguration) {
        this.fedletConfiguration = fedletConfiguration;
        this.configuredParamsMap = new HashMap<String, List<String>>();

        // Some defaults:
        configuredParamsMap.put(NAMEID_POLICY_FORMAT, Collections.singletonList(NAMEID_TRANSIENT_FORMAT));
        configuredParamsMap.put(REQ_BINDING, Collections.singletonList(HTTP_REDIRECT));
    }

    public void send(HttpServletRequest request, HttpServletResponse response) throws SAML2Exception {
        send(request, response);
    }

    public void send(HttpServletRequest request, HttpServletResponse response, Map<String,List<String>> authnRequestParams) throws SAML2Exception {
        Map<String, List> requestParamsMap = SAML2Utils.getParamsMap(request);

        // overwrite with parameters configured for this instance:
        requestParamsMap.putAll(this.configuredParamsMap);

        // overwrite again with parameters passed in method invocation:
        requestParamsMap.putAll(authnRequestParams);

        logger.info("Sending Authentication request to IPD " + fedletConfiguration.getIdpEntityId() +
                " with the following parameters: " + requestParamsMap);
        SPSSOFederate.initiateAuthnRequest(request, response, fedletConfiguration.getSpMetaAlias(),
                fedletConfiguration.getIdpEntityId(), requestParamsMap);


    }

}
