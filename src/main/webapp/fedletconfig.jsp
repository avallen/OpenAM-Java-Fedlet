<%@ page import="com.hmg.servicecloud.fedlet.util.FedletConfiguration" %>

<%
    FedletConfiguration fedletConfig = (FedletConfiguration) application.getAttribute("fedletConfig");
    com.hmg.servicecloud.fedlet.saml.SAMLRequestSender samlRequestSender =
            (com.hmg.servicecloud.fedlet.saml.SAMLRequestSender) application.getAttribute("samlSender");

    String fedletBaseUrl = null, spEntityID = null, spMetaAlias = null, idpEntityID = null, idpMetaAlias = null, idpBaseUrl = null;

    if (fedletConfig != null) {
        fedletBaseUrl = fedletConfig.getSpBaseUrl();
        spEntityID = fedletConfig.getSpEntityId();
        spMetaAlias = fedletConfig.getSpMetaAlias();
        idpEntityID = fedletConfig.getIdpEntityId();
        idpMetaAlias = fedletConfig.getIdpMetaAlias();
        idpBaseUrl = fedletConfig.getIdpBaseUrl();
    }
%>
