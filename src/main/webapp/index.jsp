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
<%@ page import="com.hmg.servicecloud.fedlet.util.FedletMetaData" %>
<%@ page import="com.hmg.servicecloud.fedlet.util.FedletUtils" %>
<%@ page import="com.sun.identity.saml2.meta.SAML2MetaException" %>


<%--
    index.jsp contains links to test SP or IDP initiated Single Sign-on
--%>
<html>

<head>
    <title>Validate Fedlet Setup</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/com_sun_web_ui/css/css_ns6up.css"/>
</head>

<body>
<div class="MstDiv">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="MstTblTop" title="">
        <tbody>
        <tr>
            <td nowrap="nowrap">&nbsp;</td>
            <td nowrap="nowrap">&nbsp;</td>
        </tr>
        </tbody>
    </table>

    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="MstTblBot" title="">
        <tbody>
        <tr>
            <td class="MstTdTtl" width="99%">
                <div class="MstDivTtl"><img name="ProdName"
                                            src="<%= request.getContextPath() %>/console/images/PrimaryProductName.png"
                                            alt=""/></div>
            </td>
            <td class="MstTdLogo" width="1%"><img name="RMRealm.mhCommon.BrandLogo"
                                                  src="<%= request.getContextPath() %>/com_sun_web_ui/images/other/javalogo.gif"
                                                  alt="Java(TM) Logo" border="0" height="55" width="31"/></td>
        </tr>
        </tbody>
    </table>
    <table class="MstTblEnd" border="0" cellpadding="0" cellspacing="0" width="100%">
        <tbody>
        <tr>
            <td><img name="RMRealm.mhCommon.EndorserLogo"
                     src="<%= request.getContextPath() %>/com_sun_web_ui/images/masthead/masthead-sunname.gif"
                     alt="Sun(TM) Microsystems, Inc." align="right" border="0" height="10" width="108"/></td>
        </tr>
        </tbody>
    </table>
</div>
<div class="SkpMedGry1"><a id="SkipAnchor2089"></a></div>
<div class="SkpMedGry1"><a href="#SkipAnchor4928"><img
        src="<%= request.getContextPath() %>/com_sun_web_ui/images/other/dot.gif"
        alt="Jump Over Tab Navigation Area. Current Selection is: Access Control"
        border="0" height="1" width="1"/></a></div>

<%
    FedletUtils fedletUtil = new FedletUtils(application);

    try {
        if ("true".equalsIgnoreCase(request.getParameter("CreateConfig"))) {
            fedletUtil.copyConfigurationFilesToDir();
%>
            <p><br><b>Fedlet configuration created under "<%=fedletUtil.getFedletConfigDir()%>" directory.</b>
            <br><br>Click <a href="index.jsp">here</a> to continue.</body></html>
<%
          return;
        }

        if (!fedletUtil.fedletConfigurationExists()) { %>
            <p/><br><b>Fedlet configuration home directory does not exist or FederationConfig.properties could not be found in it.</b>

            <% if (fedletUtil.hasConfigFileIncludedInWar()) { %>
                    <br><br>Click <a href="index.jsp?CreateConfig=true">here</a> to create Fedlet configuration automatically.
                    <br>Or manually extract your fedlet.war and copy all files under "conf" directory to "<%= fedletUtil.getFedletConfigDir() %>" directory, then restart your web container.
             <% } else { %>
                   <br/>Please follow the README bundled inside your Fedlet-unconfigured.zip file to setup Fedlet configuration, then restart your web container.
             <% } %>
             </body></html>
             <%
             return;
        }

        FedletMetaData metaData = null;
        try {
            metaData = FedletMetaData.createFromMetaData(application);
        } catch (SAML2MetaException e) { %>
            <p><br><b>Fedlet or remote Identity Provider metadata is not configured.</b>
         <%
            if (fedletUtil.hasConfigFileIncludedInWar()) { %>
                <p/><br>Click <a href="index.jsp?CreateConfig=true">here</a> to create Fedlet configuration automatically.
                <br>Or manually extract your fedlet.war and copy all files under "conf" directory to "<%=fedletUtil.getFedletConfigDir()%>" directory, then restart your web container.
          <%} else { %>
                <br>Please follow the README bundled inside your Fedlet-unconfigured.zip file to setup Fedlet configuration, then restart your web container.
          <%}%>
            </body></html>
        <%return;
        } %>

<%
        String fedletBaseUrl = metaData.getSpBaseUrl();
        String spEntityID = metaData.getSpEntityId();
        String spMetaAlias = metaData.getSpMetaAlias();
        String idpEntityID = metaData.getIdpEntityId();
        String idpMetaAlias = metaData.getIdpMetaAlias();
        String idpBaseUrl = metaData.getIdpBaseUrl();

%>

<h2>Validate Fedlet Setup</h2>

<p><br>
<table border="0" width="700">
    <tr>
        <td colspan="2">
            Click following links to start Fedlet(SP) and/or IDP initiated
            Single Sign-On. Upon successful completion, you will be presented
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
    <tr>
        <td colspan="2"></td>
    </tr>
    <tr>
        <td><b>Fedlet (SP) Configuration Directory:&nbsp;&nbsp;</b></td>
        <td><%= fedletUtil.getFedletConfigDir() %>
        </td>
    </tr>
    <tr>
        <td><b>Fedlet (SP) Entity ID:</b>&nbsp;&nbsp;&nbsp;&nbsp;</td>
        <td><%= spEntityID %>
        </td>
    </tr>
    <tr>
        <td><b>IDP Entity ID:</b></td>
        <td><%= idpEntityID %>
        </td>
    </tr>
    <tr>
        <td colspan="2"></td>
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
<%
    } catch (Exception e) {
        e.printStackTrace();
        response.sendError(response.SC_INTERNAL_SERVER_ERROR,e.getMessage());
    }
%>
</body>
</html>
