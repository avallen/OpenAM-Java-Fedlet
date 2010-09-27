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
<%@ page import="com.hmg.servicecloud.fedlet.util.FedletConfiguration" %>
<%@ page import="com.hmg.servicecloud.fedlet.util.FedletUtils" %>
<%@ page import="com.sun.identity.saml2.meta.SAML2MetaException" %>

<%@include file="fedletconfig.jsp" %>
<%@include file="header.jsp" %>

<h2>Page protected with the session check filter</h2>

Accessing this page shall trigger the session check filter.

    </body>
</html>
