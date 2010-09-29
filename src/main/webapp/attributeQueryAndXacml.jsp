
<%-- HMG does not support these usecases, so we hide them in this JSP. --%>

<%@include file="header.jsp"%>
<%@include file="samlVars.jsp"%>

<%
out.print("<p><p>");
out.println("<br><b>Test Attribute Query:</b></br>");
out.print("<p><p>");
out.print("<b><a href=" + request.getContextPath() + "/fedletAttrQuery.jsp?nameIDValue=" + value + "&idpEntityID=" + responseIDPentityID + "&spEntityID=" + responseSPEntityID + ">Fedlet Attribute Query </a></b>");
out.print("<p><p>");

out.println("<br><b>Test XACML Policy Decision Query:</b></br>");
out.print("<p><p>");
out.print("<b><a href=" + request.getContextPath() + "/fedletXACMLQuery.jsp?nameIDValue=" + value + "&idpEntityID=" + responseIDPentityID + "&spEntityID=" + responseSPEntityID + ">Fedlet XACML Query </a></b>");
out.print("<p><p>");
%>