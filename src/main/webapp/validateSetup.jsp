<%@ page import="com.hmg.servicecloud.fedlet.util.FedletConfiguration" %>
<%@ page import="com.hmg.servicecloud.fedlet.util.FedletUtils" %>
<%@ page import="com.sun.identity.saml2.meta.SAML2MetaException" %>

<%@include file="header.jsp" %>

<h2>Validate Fedlet Setup</h2>

<%
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
                   <br/>Please follow the README bundled in the zip file to setup Fedlet configuration, then restart your web container.
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
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendError(response.SC_INTERNAL_SERVER_ERROR,e.getMessage());
    }
%>
<p><br>
Configuration directory exists and the configuration could successfully be loaded:
<table border="0" width="700">
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


