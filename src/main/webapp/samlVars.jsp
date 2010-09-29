<%@ page import="com.hmg.servicecloud.fedlet.saml.SAMLResponse" %>
<%@ page import="com.sun.identity.saml2.assertion.Assertion" %>
<%@ page import="com.sun.identity.saml2.assertion.NameID" %>
<%@ page import="com.sun.identity.saml2.assertion.Subject" %>
<%@ page import="com.sun.identity.saml2.protocol.Response" %>
<%@ page import="com.hmg.servicecloud.fedlet.util.FedletConstants" %>
<%

    // Following code shows how to retrieve information,
    // such as Reponse/Assertion/Attributes, from the returned map.
    // You might not need them in your real application code.

    // The SimpleUserSessionAdapter puts the SAMLResponse object in the
    // session in case of successful verification.
    SAMLResponse samlResponse = (SAMLResponse) session.getAttribute(FedletConstants.SAML_RESPONSE_ATTR);

    Response samlResp = null;
    Assertion assertion = null;
    Subject responseSubject = null;
    String responseIDPentityID = "";
    String responseSPEntityID = "";
    String sessionIndex = "";
    NameID nameId = null;
    String value = "";
    String format = "";

    if (samlResponse != null) {
        samlResp = samlResponse.getResponse();
        assertion = samlResponse.getAssertion();
        responseSubject = samlResponse.getResponseSubject();
        responseIDPentityID = samlResponse.getResponseIDPentityID();
        responseSPEntityID = samlResponse.getResponseSPEntityID();
        nameId = samlResponse.getNameId();
        sessionIndex = samlResponse.getSessionIndex();
        if (samlResponse.getNameId() != null) {
            value = nameId.getValue();
            format = nameId.getFormat();
        }
    }
%>