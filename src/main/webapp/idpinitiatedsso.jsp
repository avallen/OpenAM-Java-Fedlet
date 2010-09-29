<%@include file="header.jsp" %>


<p><br>
<table border="0" width="700">
    <tr>
        <td colspan="2">
            Click following links to make the IDP send the SP a so-called
            "IDP-initiated" SAML Response, that means the IDP sends a SAML Response
            without first receiving a SAML Authentication Request.
            <br/>
            Upon successful completion, you will be presented
            with a page to display the Single Sign-On Response, Assertion and
            AttributeStatement received from IDP side.
        </td>
    </tr>
    <tr>
        <td colspan="2"></td>
    </tr>
    <tr>
        <td colspan="2"></td>
    </tr>
    <%
        if ((idpMetaAlias != null) && (idpMetaAlias.length() != 0)) {
            //remote IDP is also FAM, show IDP initiated SSO
    %>
    <tr>
        <td colspan="2"></td>
    </tr>
    <tr>
        <td colspan="2"><a
                href="<%= idpBaseUrl %>/idpssoinit?NameIDFormat=urn:oasis:names:tc:SAML:2.0:nameid-format:transient&metaAlias=<%= idpMetaAlias %>&spEntityID=<%=spEntityID %>&binding=urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST">Run
            Identity Provider initiated Single Sign-On using HTTP POST binding</a></td>
    </tr>
    <tr>
        <td colspan="2"><a
                href="<%= idpBaseUrl %>/idpssoinit?NameIDFormat=urn:oasis:names:tc:SAML:2.0:nameid-format:transient&metaAlias=<%= idpMetaAlias %>&spEntityID=<%=spEntityID %>&binding=urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Artifact">Run
            Identity Provider initiated Single Sign-On using HTTP Artifact binding</a></td>
    </tr>
    <%
        }
    %>
    <tr>
        <td colspan="2"></td>
    </tr>
</table>

<%@include file="samlSessionProperties.jsp"%>