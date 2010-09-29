<%@ page import="com.hmg.servicecloud.fedlet.adapter.SimpleUserSessionAdapter" %>
<%@ page import="com.hmg.servicecloud.fedlet.adapter.UserSessionAdapter" %>
<%@ page import="com.hmg.servicecloud.fedlet.saml.SAMLRequestSender" %>
<%@ page import="com.hmg.servicecloud.fedlet.util.FedletConfiguration" %>
<%@ page import="com.hmg.servicecloud.fedlet.util.FedletUtils" %>

<%
    FedletConfiguration fedletConfig = (FedletConfiguration) application.getAttribute("fedletConfig");
    SAMLRequestSender samlRequestSender =
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
    FedletUtils fedletUtil = new FedletUtils(application);
    UserSessionAdapter userSessionAdapter = new SimpleUserSessionAdapter();
%>