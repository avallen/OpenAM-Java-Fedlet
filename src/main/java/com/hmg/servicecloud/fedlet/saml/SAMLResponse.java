package com.hmg.servicecloud.fedlet.saml;

import com.sun.identity.saml2.assertion.NameID;
import com.sun.identity.saml2.common.SAML2Constants;

import java.io.Serializable;
import java.util.Map;

import com.sun.identity.saml.common.SAMLUtils;
import com.sun.identity.saml2.assertion.Assertion;
import com.sun.identity.saml2.assertion.NameID;
import com.sun.identity.saml2.assertion.Subject;
import com.sun.identity.saml2.common.SAML2Constants;
import com.sun.identity.saml2.common.SAML2Exception;
import com.sun.identity.saml2.profile.SPACSUtils;
import com.sun.identity.saml2.protocol.Response;
import com.sun.identity.shared.encode.URLEncDec;


/**
 * Wrapper Object for the Map<String,String> object that describes the
 * received SAML Response.
 *
 * @author Andreas Vallen
 */
public class SAMLResponse implements Serializable {
    
    private Response response;
    private Assertion assertion;
    private Subject responseSubject;
    private String responseIDPentityID;
    private String responseSPEntityID;
    private NameID nameId;
    private String nameIdValue;
    private String nameIdFormat;
    private String sessionIndex;
    private Map attributes;
    private String relayState;

    public SAMLResponse(Map map) {
        // Following are sample code to show how to retrieve information,
        // such as Reponse/Assertion/Attributes, from the returned map.
        // You might not need them in your real application code.
        this.response = (Response) map.get(SAML2Constants.RESPONSE);
        this.assertion = (Assertion) map.get(SAML2Constants.ASSERTION);
        this.responseSubject = (Subject) map.get(SAML2Constants.SUBJECT);
        this.responseIDPentityID = (String) map.get(SAML2Constants.IDPENTITYID);
        this.responseSPEntityID = (String) map.get(SAML2Constants.SPENTITYID);
        this.nameId = (NameID) map.get(SAML2Constants.NAMEID);
        this.nameIdValue = nameId.getValue();
        this.nameIdFormat = nameId.getFormat();
        this.sessionIndex = (String) map.get(SAML2Constants.SESSION_INDEX);
        this.attributes = (Map) map.get(SAML2Constants.ATTRIBUTE_MAP);
        this.relayState = (String) map.get(SAML2Constants.RELAY_STATE);
    }

    public Response getResponse() {
        return response;
    }

    public Assertion getAssertion() {
        return assertion;
    }

    public Subject getResponseSubject() {
        return responseSubject;
    }

    public String getResponseIDPentityID() {
        return responseIDPentityID;
    }

    public String getResponseSPEntityID() {
        return responseSPEntityID;
    }

    public NameID getNameId() {
        return nameId;
    }

    public String getNameIdValue() {
        return nameIdValue;
    }

    public String getNameIdFormat() {
        return nameIdFormat;
    }

    public String getSessionIndex() {
        return sessionIndex;
    }

    public Map getAttributes() {
        return attributes;
    }

    public String getRelayState() {
        return relayState;
    }
}
