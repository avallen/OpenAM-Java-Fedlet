package com.hmg.servicecloud.fedlet.adapter;

import com.hmg.servicecloud.fedlet.saml.SAMLResponse;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * @author Andreas Vallen
 */
public class SimpleUserSessionAdapter implements UserSessionAdapter {

    public void createUserSessionFromValidatedSAMLResponse(HttpServletRequest request, SAMLResponse samlResponse) {
        final HttpSession session = request.getSession();
        session.setAttribute("SAML_RESPONSE", samlResponse);
        session.setAttribute("SAML_SESSION_INDEX", samlResponse.getSessionIndex());
    }

}
