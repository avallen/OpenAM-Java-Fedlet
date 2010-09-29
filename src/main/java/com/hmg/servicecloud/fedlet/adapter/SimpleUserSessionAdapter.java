package com.hmg.servicecloud.fedlet.adapter;

import com.hmg.servicecloud.fedlet.saml.SAMLResponse;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

/**
 * Simple example of a UserSessionAdapter.
 * <p/>
 * This is a naive demo implementation that will lead to a memory leak and
 * should not be used as-is in production.
 *
 * @author Andreas Vallen
 */
public class SimpleUserSessionAdapter implements UserSessionAdapter {

    private static Logger logger = Logger.getLogger(SimpleUserSessionAdapter.class.getName());

    // TODO: this is a memory leak, production implementation must make sure
    // not to hold on to HttpSession objects that refer to invalidated Sessions,
    // where invalidation can occur by other means than being invalidated by
    // this class.
    private static Map<String, HttpSession> sessionIndexToSessionMap = Collections.synchronizedMap(new HashMap<String, HttpSession>());
    public static final String SAML_RESPONSE_ATTR = "SAML_RESPONSE_ATTR";

    public void createUserSessionFromValidatedSAMLResponse(HttpServletRequest request, SAMLResponse samlResponse) {
        final HttpSession session = request.getSession();
        session.setAttribute(SAML_RESPONSE_ATTR, samlResponse);
        String sessionIndex = samlResponse.getSessionIndex();
        if (sessionIndex == null) {
            throw new IllegalStateException("Unexpected error: a supposedly validated sucessful SAML Response does not contain a sessionIndex value!");
        }
        // creates a session if it does not exist already:
        sessionIndexToSessionMap.put(sessionIndex, request.getSession());
    }

    public boolean hasSamlSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        return session.getAttribute(SAML_RESPONSE_ATTR) != null;
    }

    public void invalidateSessionForSamlSessionIndex(String sessionIndex) {
        logger.info("Try to invalidate Session with SAML SessionIndex: " + sessionIndex);
        final HttpSession httpSession = sessionIndexToSessionMap.get(sessionIndex);
        if (httpSession != null) {
            httpSession.invalidate();
            logger.info("Done.");
        } else {
            logger.warning("No session found for this SAML SessionIndex!");
        }
    }

}
