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

   $Id: index.jsp,v 1.14 2009/06/09 20:28:30 exu Exp $

--%>
<%@page
        import="com.hmg.servicecloud.fedlet.servlet.SAMLSessionCheckFilter,
                com.hmg.servicecloud.fedlet.saml.SAMLResponse,
                com.sun.identity.saml2.assertion.Assertion,
                com.sun.identity.saml2.assertion.NameID,
                com.sun.identity.saml2.assertion.Subject,
                com.sun.identity.saml2.common.SAML2Constants,
                com.sun.identity.saml2.protocol.Response,
                com.sun.identity.shared.encode.URLEncDec" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hmg.servicecloud.fedlet.servlet.SAMLSessionCheckFilter" %>

<%@include file="fedletconfig.jsp" %>
<%@include file="header.jsp" %>


<h2>Page protected with the session check filter</h2>

This page is configured to execute the SessionCheckFilter on each access.
<p/>
The filter triggers a passive Authentication Request if one hasn't been issued for more than one minute.
<p/>

<%
    Long lastSessionCheckTimeUnixSeconds = (Long) session.getAttribute(SAMLSessionCheckFilter.LAST_SESSIONCHECK);
    long currentTimeUnixEpochSeconds = new Date().getTime() / 1000L;
    long secondsSinceLastCheck = -1;
    if (lastSessionCheckTimeUnixSeconds != null) {
        secondsSinceLastCheck = currentTimeUnixEpochSeconds - lastSessionCheckTimeUnixSeconds;
    }
    %>
Seconds since last Session check: <%= secondsSinceLastCheck %>

<%

    // Following are sample code to show how to retrieve information,
    // such as Reponse/Assertion/Attributes, from the returned map.
    // You might not need them in your real application code.
    SAMLResponse samlResponse = (SAMLResponse) session.getAttribute("SAML_RESPONSE");

    if (samlResponse == null || samlResponse.getAssertion() == null || samlResponse.getNameId() == null) {
        return;
    }

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
    %>

    </body>
</html>
