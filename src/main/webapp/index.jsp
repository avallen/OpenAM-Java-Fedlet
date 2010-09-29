<%@include file="header.jsp" %>

<p><br>
<table border="0" width="700">
    <tr>
        <td colspan="2">
            Click following links to send an Authenticatoin Request from the Fedlet(SP)
            to the IDP.
        </td>
    </tr>
    <tr>
        <td colspan="2"></td>
    </tr>
    <tr>
        <td colspan="2"><a
                href="<%= fedletBaseUrl %>/saml2/jsp/fedletSSOInit.jsp?metaAlias=<%= spMetaAlias %>&idpEntityID=<%= idpEntityID%>&binding=urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST">Run
            Fedlet (SP) initiated Single Sign-On using HTTP POST binding</a></td>
    </tr>
    <tr>
        <td colspan="2"><a
                href="<%= fedletBaseUrl %>/saml2/jsp/fedletSSOInit.jsp?metaAlias=<%= spMetaAlias %>&idpEntityID=<%= idpEntityID %>&binding=urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Artifact">Run
            Fedlet (SP) initiated Single Sign-On using HTTP Artifact binding</a></td>
    </tr>
    <tr>
        <td colspan="2"><a
                href="<%= fedletBaseUrl %>/saml2/jsp/fedletSSOInit.jsp?binding=urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST&IsPassive=true">Run
            Fedlet (SP) initiated <b><i>passive</i></b>Single Sign-On using HTTP POST binding</a></td>
    </tr>
</table>

<%@include file="samlSessionProperties.jsp"%>
