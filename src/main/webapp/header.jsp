<%@include file="fedletconfig.jsp" %>

<html>

<head>
    <title>OpenAM Fedlet</title>
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
<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tbody>
    <tr>
        <td>
            <a href="<%= request.getContextPath() %>/validateSetup.jsp">Validate Setup</a>&nbsp;|&nbsp;
            <a href="<%= request.getContextPath() %>/sessionCheck.jsp">Automatic Session Check</a>&nbsp;|&nbsp;
            <a href="<%= request.getContextPath() %>/index.jsp">SSO Request SP->IDP</a>&nbsp;|&nbsp;
            <a href="<%= request.getContextPath() %>/idpinitiatedsso.jsp">SSO Response IDP->SP</a>&nbsp;|&nbsp;
            <% if (userSessionAdapter.hasSamlSession(request)) { %>
            <a href="<%= request.getContextPath() %>/spinitiatedslo.jsp">SLO Request SP->IDP</a>&nbsp;|&nbsp;
            <a href="<%= request.getContextPath() %>/idpinitiatedslo.jsp">SLO Request IDP->SP</a>&nbsp;|&nbsp;
            <% } %>
        </td>
    </tr>
    </tbody>
</table>

<%@include file="samlVars.jsp" %>
