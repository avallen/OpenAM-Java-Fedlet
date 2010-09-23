package com.hmg.servicecloud.fedlet.adapter;

import com.hmg.servicecloud.fedlet.saml.SAMLResponse;

import javax.servlet.http.HttpServletRequest;

/**
 * @author Andreas Vallen
 */
public interface UserSessionAdapter {

    public void createUserSessionFromValidatedSAMLResponse(HttpServletRequest request, SAMLResponse samlResponse);

}
