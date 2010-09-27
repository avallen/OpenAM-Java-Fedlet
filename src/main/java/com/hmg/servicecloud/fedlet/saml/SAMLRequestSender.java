package com.hmg.servicecloud.fedlet.saml;

import com.hmg.servicecloud.fedlet.util.FedletConfiguration;
import com.sun.identity.saml2.common.SAML2Exception;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URL;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.sun.identity.saml2.common.SAML2Constants.ISPASSIVE;
import static com.sun.identity.saml2.common.SAML2Constants.TRUE;

/**
 * @author Andreas Vallen
 */
public class SAMLRequestSender {

    private AuthenticationRequestSender defaultAuthnRequestSender;
    private AuthenticationRequestSender passiveAuthnRequestSender;

    public SAMLRequestSender(FedletConfiguration fedletConfiguration) {
        this.defaultAuthnRequestSender = new AuthenticationRequestSender(fedletConfiguration);
        this.passiveAuthnRequestSender = configurePassiveAuthenticationRequestSender(fedletConfiguration);
    }

    private AuthenticationRequestSender configurePassiveAuthenticationRequestSender(FedletConfiguration fedletConfiguration) {
        Map passiveAuthnRequestParams = new HashMap<String, List<String>>();
        passiveAuthnRequestParams.put(ISPASSIVE, Collections.singletonList(TRUE));
        return new AuthenticationRequestSender(fedletConfiguration, passiveAuthnRequestParams);
    }

    public void sendAuthnRequest(HttpServletRequest request, HttpServletResponse response) throws SAML2Exception {
        this.defaultAuthnRequestSender.send(request, response);
    }

    public void sendPassiveAuthnRequest(HttpServletRequest request, HttpServletResponse response) throws SAML2Exception {
        this.passiveAuthnRequestSender.send(request, response);
    }

    public void sendPassiveAuthnRequestReturnTo(HttpServletRequest request, HttpServletResponse response, String returnToUrl) throws SAML2Exception {
        this.passiveAuthnRequestSender.send(request, response,
                Collections.singletonMap("RelayState", Collections.singletonList(returnToUrl)));
    }

}
