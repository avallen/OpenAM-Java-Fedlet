<%@ page import="com.hmg.servicecloud.fedlet.saml.SAMLResponse" %>
<%@ page import="com.sun.identity.saml2.assertion.Assertion" %>
<%@ page import="com.sun.identity.saml2.assertion.NameID" %>
<%@ page import="com.sun.identity.saml2.assertion.Subject" %>
<%@ page import="com.sun.identity.saml2.protocol.Response" %>
<%

    // Following are sample code to show how to retrieve information,
// such as Reponse/Assertion/Attributes, from the returned map.
// You might not need them in your real application code.
    SAMLResponse samlResponse = (SAMLResponse) session.getAttribute("SAML_RESPONSE");

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