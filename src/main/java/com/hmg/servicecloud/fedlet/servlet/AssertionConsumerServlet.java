package com.hmg.servicecloud.fedlet.servlet;

import com.hmg.servicecloud.fedlet.adapter.UserSessionAdapter;
import com.hmg.servicecloud.fedlet.saml.SAMLResponse;
import com.hmg.servicecloud.fedlet.saml.SAMLResponseProcessor;
import com.sun.identity.saml.common.SAMLUtils;
import com.sun.identity.saml2.common.SAML2Exception;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * @author Andreas Vallen
 */
public class AssertionConsumerServlet extends javax.servlet.http.HttpServlet {

    private final Logger logger = Logger.getLogger(this.getClass().getName());

    UserSessionAdapter userSessionAdapter;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        String userSessionAdapterClass = config.getServletContext().getInitParameter("UserSessionAdapterClass");
        if (userSessionAdapterClass == null) {
            throw new IllegalStateException("The servlet " + this.getClass().getName() + " misses the required " +
                    "ServletContext init parameter 'UserSessionAdapterClass'. Please configure it in web.xml");
        }
        try {
            userSessionAdapter = (UserSessionAdapter) Class.forName(userSessionAdapterClass).newInstance();
        } catch (Exception e) {
            throw new IllegalStateException("Missing implementation class for the UserSessionAdapter interface " +
                    "that was configured in web.xml: " + userSessionAdapterClass + ". Please make sure the class" +
                    "that is configured in web.xml is contained in your application.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        SAMLResponse samlResponse;
        try {
            samlResponse = SAMLResponseProcessor.processRequest(request, response);
        } catch (SAML2Exception e) {

            // Some error processing is done already, for example by our own FedletServiceProviderAdapter
            // failure handlers. In the process a redirect might already have been performed. In this
            // case there remains nothing to be done here, in fact it is not possible anymore
            // to write to the response, because it has already been redirected.
            if (e.isRedirectionDone()) {
                logger.info("The validation of the SAML response failed. A redirect has already been" +
                        "performed by the validation code.");
                return;
            }

            logger.warning("Some error occured during processing, see stdout. " +
                    "TODO: if this is an error that must be handled, then add the corresponding logic to AssertionConsumerServlet.");
            e.printStackTrace();

            SAMLUtils.sendError(request, response,
                  response.SC_INTERNAL_SERVER_ERROR, "failedToProcessSSOResponse",
                  e.getMessage());

            return;
        }

        userSessionAdapter.createUserSessionFromValidatedSAMLResponse(request, samlResponse);

        String relayUrl = samlResponse.getRelayState();

        if (relayUrl == null) {
            // in this case the SAML processing logic has already issued a redirect and
            // the response is comitted - it must not be written to it anymore, so just
            // return.
            logger.info("SAML response has no relayState value this possibly means there was a processing error. " +
                    "Will not perform a redirect as the resonse should already be committed.");
            return;
        }

        logger.info("SAML response contains relayState, will redirect to its value: " + relayUrl);
        response.sendRedirect(relayUrl);
        return;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
