package com.hmg.servicecloud.fedlet.saml;

import com.hmg.servicecloud.fedlet.util.FedletConfiguration;
import com.sun.identity.saml2.common.SAML2Exception;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.logging.Logger;

/**
 * @author Andreas Vallen
 */
public class SAMLRequestSender {

    private AuthenticationRequestSender defaultAuthnRequestSender;
    private AuthenticationRequestSender passiveAuthnRequestSender;


    public SAMLRequestSender(FedletConfiguration fedletConfiguration) {
        this.defaultAuthnRequestSender = new AuthenticationRequestSender(fedletConfiguration);
        this.passiveAuthnRequestSender = new AuthenticationRequestSender(fedletConfiguration);
        this.passiveAuthnRequestSender.setIsPassive(true);
    }

    public void sendAuthnRequest(HttpServletRequest request, HttpServletResponse response) throws SAML2Exception {
        this.defaultAuthnRequestSender.send(request, response);
    }

    public void sendPassiveAuthnRequest(HttpServletRequest request, HttpServletResponse response) throws SAML2Exception {
        this.passiveAuthnRequestSender.send(request, response);
    }

}
