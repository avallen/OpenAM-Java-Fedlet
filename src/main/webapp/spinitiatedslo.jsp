<%@ page import="com.sun.identity.shared.encode.URLEncDec" %>
<%@include file="header.jsp" %>

<p><br>

    <%
        String commonRequestParams = "spEntityID=" + URLEncDec.encode(responseSPEntityID) +
                "&idpEntityID=" + URLEncDec.encode(responseIDPentityID) +
                "&NameIDValue=" + URLEncDec.encode(value) +
                "&SessionIndex=" + URLEncDec.encode(sessionIndex) +
                "&RelayState=" + URLEncDec.encode(fedletBaseUrl + "/index.jsp");
    %>

    <br><b><a href="<%=fedletBaseUrl%>/fedletSloInit?<%=commonRequestParams%>&binding=urn:oasis:names:tc:SAML:2.0:bindings:SOAP">
    Run Fedlet initiated Single Logout using SOAP binding</a></b></br>
    <br><b><a href="<%=fedletBaseUrl%>/fedletSloInit?<%=commonRequestParams%>&binding=urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect">
    Run Fedlet initiated Single Logout using HTTP Redirect binding</a></b></br>
    <br><b><a href="<%=fedletBaseUrl%>/fedletSloInit?<%=commonRequestParams%>&binding=urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST">
    Run Fedlet initiated Single Logout using HTTP POST binding</a></b></br>

    <%@include file="samlSessionProperties.jsp"%>
