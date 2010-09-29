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
<%@page import="com.hmg.servicecloud.fedlet.servlet.SAMLSessionCheckFilter,
        com.hmg.servicecloud.fedlet.servlet.SAMLSessionCheckFilter,
        java.util.Date" %>

<%@include file="header.jsp" %>

<h2>Page protected with the session check filter</h2>

This page is configured to execute the SessionCheckFilter on each access.
<p/>
The filter triggers a passive Authentication Request if the user has no SAML session and<br/>
it has not checked for a session in the last <b><%= application.getAttribute("sessionCheckIntervalSeconds") %></b> seconds.<br/>
<br/>
This interval is configured as a servlet filter init parameter in this demo.
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

<%@include file="samlSessionProperties.jsp"%>
