package com.hmg.servicecloud.fedlet.adapter;

import com.sun.identity.saml2.plugins.SAML2ServiceProviderAdapter;
import com.sun.identity.saml2.protocol.AuthnRequest;
import com.sun.identity.saml2.protocol.Response;
import com.sun.identity.saml2.protocol.Status;
import com.sun.identity.saml2.protocol.StatusCode;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;
import java.util.logging.Logger;

/**
 * @author Andreas Vallen
 */
public class FedletServiceProviderAdapter extends SAML2ServiceProviderAdapter {

     private final Logger logger = Logger.getLogger(this.getClass().getName());

    /**
     * this method allows the configuration of the adapter from parameters configured
     * in the sp-extended.xml configuration file's "spAdapterEnv" element.
     *
     * @param map
     */
    @Override
    public void initialize(Map map) {
        return; // no need to configure the adapter yet.
    }

    @Override
    public boolean postSingleSignOnFailure(String hostedEntityID, String realm, HttpServletRequest request, HttpServletResponse response, AuthnRequest authnRequest, Response ssoResponse, String profile, int failureCode) {

        Status status = ssoResponse.getStatus();
        StatusCode statusCode = status.getStatusCode();
        String statusCodeValue = statusCode != null ? statusCode.getValue() : "";
        StatusCode subStatusCode = statusCode.getStatusCode();
        String subStatusCodeValue = subStatusCode != null ? subStatusCode.getValue() : "";

        logger.info("SAML Single Sign On request failed with with StatusCode " + statusCodeValue);

        // This is how it should be once OpenSSO returns the correct Status code:
        //  if (statusCodeValue.equals(SAML2Constants.RESPONDER) && subStatusCodeValue.equals(SAML2Constants.NO_PASSIVE)) {

        // For now we always simply do a redirect to the return to URL that was
        // stored in the session.
        final HttpSession session = request.getSession();

        final String returnToUrl = (String) session.getAttribute("FEDLET_RETURN_TO_URL");
        if (returnToUrl != null) {
            logger.info("The session attribute FEDLET_RETURN_TO_URL is set, performing a redirect to this URL: "
                    + returnToUrl);
            try {
                response.sendRedirect(returnToUrl);
            } catch (IOException e) {
            }
            return true; // in any case, if the redirect fails there has possibly already been another redirection.
        } else {
            logger.info("Did not find a FEDLET_RETURN_TO_URL that could be used to redirect to after the error.");
            return false;
        }
    }

}
