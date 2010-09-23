package com.hmg.servicecloud.fedlet.saml;

import com.sun.identity.plugin.session.SessionException;
import com.sun.identity.saml2.common.SAML2Exception;
import com.sun.identity.saml2.profile.SPACSUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

/**
 * @author Andreas Vallen
 */
public class SAMLResponseProcessor {

    public static SAMLResponse processRequest(HttpServletRequest request, HttpServletResponse response) throws SAML2Exception {
        // invoke the Fedlet processing logic. this will do all the
        // necessary processing conforming to SAMLv2 specifications,
        // such as XML signature validation, Audience and Recipient
        // validation etc.
        Map map;
        try {
            map = SPACSUtils.processResponseForFedlet(request, response);
        } catch (IOException e) {
            throw new SAML2Exception(e);
        } catch (SessionException e) {
            throw new SAML2Exception(e);
        } catch (ServletException e) {
            throw new SAML2Exception(e);
        }
        return new SAMLResponse(map);
    }
}
