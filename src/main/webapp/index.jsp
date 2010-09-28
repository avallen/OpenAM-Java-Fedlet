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
<%--
    index.jsp contains links to test SP or IDP initiated Single Sign-on
--%>


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

        if (fedletConfig == null) { %>
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
    <tr>
        <td colspan="2"><a
                href="<%= fedletBaseUrl %>/saml2/jsp/fedletSSOInit.jsp?binding=urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST&IsPassive=true">Run
            Fedlet (SP) initiated <b><i>passive</i></b>Single Sign-On using HTTP POST binding</a></td>
    </tr>
    <tr>
        <td colspan="2"><a
                href="<%= fedletBaseUrl %>/sessionCheck.jsp">Access a page configured with the SessionCheck filter.</a></td>
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
