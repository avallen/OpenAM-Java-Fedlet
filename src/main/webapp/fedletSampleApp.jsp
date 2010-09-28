<%--
   DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
  
   Copyright (c) 2008 Sun Microsystems Inc. All Rights Reserved
  
   The contents of this file are subject to the terms
   of the Common Development and Distribution License
   (the License). You may not use this file except in
   compliance with the License.

   You can obtain a copy of the License at
   https://opensso.dev.java.net/public/CDDLv1.0.html or
   opensso/legal/CDDLv1.0.txt
   See the License for the specific language governing
   permission and limitations under the License.

   When distributing Covered Code, include this CDDL
   Header Notice in each file and include the License file
   at opensso/legal/CDDLv1.0.txt.
   If applicable, add the following below the CDDL Header,
   with the fields enclosed by brackets [] replaced by
   your own identifying information:
   "Portions Copyrighted [year] [name of copyright owner]"

   $Id: fedletSampleApp.jsp,v 1.15 2010/01/08 21:56:58 vimal_67 Exp $

--%>


<%@page
        import="com.hmg.servicecloud.fedlet.saml.SAMLResponse,
                com.sun.identity.saml2.assertion.Assertion,
                com.sun.identity.saml2.assertion.NameID,
                com.sun.identity.saml2.assertion.Subject,
                com.sun.identity.saml2.common.SAML2Constants,
                com.sun.identity.saml2.protocol.Response,
                com.sun.identity.shared.encode.URLEncDec,
                java.util.HashSet,
                java.util.Iterator,
                java.util.Map,
                java.util.Set" %>

<%@include file="fedletconfig.jsp" %>
<%@include file="header.jsp" %>

<%

    // Following are sample code to show how to retrieve information,
    // such as Reponse/Assertion/Attributes, from the returned map.
    // You might not need them in your real application code.
    SAMLResponse samlResponse = (SAMLResponse) session.getAttribute("SAML_RESPONSE");

    Response samlResp = samlResponse.getResponse();
    Assertion assertion = samlResponse.getAssertion();
    Subject responseSubject = samlResponse.getResponseSubject();
    String responseIDPentityID = samlResponse.getResponseIDPentityID();
    String responseSPEntityID = samlResponse.getResponseSPEntityID();
    NameID nameId = samlResponse.getNameId();
    String value = nameId.getValue();
    String format = nameId.getFormat();

    out.println("<br><br><b>Single Sign-On successful with IDP "
            + responseIDPentityID + ".</b>");
    out.println("<br><br>");
    out.println("<table border=0>");
    if (format != null) {
        out.println("<tr>");
        out.println("<td valign=top><b>Name ID format: </b></td>");
        out.println("<td>" + format + "</td>");
        out.println("</tr>");
    }
    if (value != null) {
        out.println("<tr>");
        out.println("<td valign=top><b>Name ID value: </b></td>");
        out.println("<td>" + value + "</td>");
        out.println("</tr>");
    }
    String sessionIndex = samlResponse.getSessionIndex();
    if (sessionIndex != null) {
        out.println("<tr>");
        out.println("<td valign=top><b>SessionIndex: </b></td>");
        out.println("<td>" + sessionIndex + "</td>");
        out.println("</tr>");
    }

    Map attrs = samlResponse.getAttributes();
    if (attrs != null) {
        out.println("<tr>");
        out.println("<td valign=top><b>Attributes: </b></td>");
        Iterator iter = attrs.keySet().iterator();
        out.println("<td>");
        while (iter.hasNext()) {
            String attrName = (String) iter.next();
            Set attrVals = (HashSet) attrs.get(attrName);
            if ((attrVals != null) && !attrVals.isEmpty()) {
                Iterator it = attrVals.iterator();
                while (it.hasNext()) {
                    out.println(attrName + "=" + it.next() + "<br>");
                }
            }
        }
        out.println("</td>");
        out.println("</tr>");
    }
    out.println("</table>");
    out.println("<br><br><b><a href=# onclick=toggleDisp('resinfo')>Click to view SAML2 Response XML</a></b><br>");
    out.println("<span style='display:none;' id=resinfo><textarea rows=40 cols=100>" + samlResp.toXMLString(true, true) + "</textarea></span>");

    out.println("<br><b><a href=# onclick=toggleDisp('assr')>Click to view Assertion XML</a></b><br>");
    out.println("<span style='display:none;' id=assr><br><textarea rows=40 cols=100>" + assertion.toXMLString(true, true) + "</textarea></span>");

    out.println("<br><b><a href=# onclick=toggleDisp('subj')>Click to view Subject XML</a></b><br>");
    out.println("<span style='display:none;' id=subj><br><textarea rows=10 cols=100>" + responseSubject.toXMLString(true, true) + "</textarea></span>");

    out.print("<p><p>");
    out.println("<br><b>Test Attribute Query:</b></br>");
    out.print("<p><p>");
    out.print("<b><a href=" + request.getContextPath() + "/fedletAttrQuery.jsp?nameIDValue=" + value + "&idpEntityID=" + responseIDPentityID + "&spEntityID=" + responseSPEntityID + ">Fedlet Attribute Query </a></b>");
    out.print("<p><p>");

    out.println("<br><b>Test XACML Policy Decision Query:</b></br>");
    out.print("<p><p>");
    out.print("<b><a href=" + request.getContextPath() + "/fedletXACMLQuery.jsp?nameIDValue=" + value + "&idpEntityID=" + responseIDPentityID + "&spEntityID=" + responseSPEntityID + ">Fedlet XACML Query </a></b>");
    out.print("<p><p>");

    out.println("<br><b>Test Single Logout:</b></br>");

    if (idpMetaAlias != null) {
        out.println("<br><b><a href=\"" + idpBaseUrl + "/IDPSloInit?metaAlias=" + idpMetaAlias + "&binding=urn:oasis:names:tc:SAML:2.0:bindings:SOAP&RelayState=" + fedletBaseUrl + "/index.jsp\">Run Identity Provider initiated Single Logout using SOAP binding</a></b></br>");
        out.println("<br><b><a href=\"" + idpBaseUrl + "/IDPSloInit?metaAlias=" + idpMetaAlias + "&binding=urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect&RelayState=" + fedletBaseUrl + "/index.jsp\">Run Identity Provider initiated Single Logout using HTTP Redirect binding</a></b></br>");
        out.println("<br><b><a href=\"" + idpBaseUrl + "/IDPSloInit?metaAlias=" + idpMetaAlias + "&binding=urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST&RelayState=" + fedletBaseUrl + "/index.jsp\">Run Identity Provider initiated Single Logout using HTTP POST binding</a></b></br>");
    }
    out.println("<br><b><a href=\"" + fedletBaseUrl + "/fedletSloInit?spEntityID=" + URLEncDec.encode(responseSPEntityID) + "&idpEntityID=" + URLEncDec.encode(responseIDPentityID) + "&NameIDValue=" + URLEncDec.encode(value) + "&SessionIndex=" + URLEncDec.encode(sessionIndex) + "&binding=urn:oasis:names:tc:SAML:2.0:bindings:SOAP&RelayState=" + URLEncDec.encode(fedletBaseUrl + "/index.jsp") + "\">Run Fedlet initiated Single Logout using SOAP binding</a></b></br>");
    out.println("<br><b><a href=\"" + fedletBaseUrl + "/fedletSloInit?spEntityID=" + URLEncDec.encode(responseSPEntityID) + "&idpEntityID=" + URLEncDec.encode(responseIDPentityID) + "&NameIDValue=" + URLEncDec.encode(value) + "&SessionIndex=" + URLEncDec.encode(sessionIndex) + "&binding=urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect&RelayState=" + URLEncDec.encode(fedletBaseUrl + "/index.jsp") + "\">Run Fedlet initiated Single Logout using HTTP Redirect binding</a></b></br>");
    out.println("<br><b><a href=\"" + fedletBaseUrl + "/fedletSloInit?spEntityID=" + URLEncDec.encode(responseSPEntityID) + "&idpEntityID=" + URLEncDec.encode(responseIDPentityID) + "&NameIDValue=" + URLEncDec.encode(value) + "&SessionIndex=" + URLEncDec.encode(sessionIndex) + "&binding=urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST&RelayState=" + URLEncDec.encode(fedletBaseUrl + "/index.jsp") + "\">Run Fedlet initiated Single Logout using HTTP POST binding</a></b></br>");
%>
<script>
    function toggleDisp(id) {
        var elem = document.getElementById(id);
        if (elem.style.display == 'none')
            elem.style.display = '';
        else
            elem.style.display = 'none';
    }
</script>
</body>
</html>
