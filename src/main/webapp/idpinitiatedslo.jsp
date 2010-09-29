<%@include file="header.jsp" %>


<p><br>
<table border="0" width="700">
    <tr>
        <td>
            Click following links to make the IDP send a SAML Single Logout Request to the IDP.
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td>

<%
    out.println("<br><b><a href=\"" + idpBaseUrl + "/IDPSloInit?metaAlias=" + idpMetaAlias + "&binding=urn:oasis:names:tc:SAML:2.0:bindings:SOAP&RelayState=" + fedletBaseUrl + "/index.jsp\">Run Identity Provider initiated Single Logout using SOAP binding</a></b></br>");
    out.println("<br><b><a href=\"" + idpBaseUrl + "/IDPSloInit?metaAlias=" + idpMetaAlias + "&binding=urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect&RelayState=" + fedletBaseUrl + "/index.jsp\">Run Identity Provider initiated Single Logout using HTTP Redirect binding</a></b></br>");
    out.println("<br><b><a href=\"" + idpBaseUrl + "/IDPSloInit?metaAlias=" + idpMetaAlias + "&binding=urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST&RelayState=" + fedletBaseUrl + "/index.jsp\">Run Identity Provider initiated Single Logout using HTTP POST binding</a></b></br>");
%>
        </td>
    </tr>
</table>


<%@include file="samlSessionProperties.jsp"%>