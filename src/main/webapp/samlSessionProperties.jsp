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

<hr/>
<%
    if (!new SimpleUserSessionAdapter().hasSamlSession(request)) {
        out.println("<br><br><b>No session created by a SAML Assertion exists.</b>");
        out.println("<br><br>");
    } else {
        out.println("<br><br><b> A Session that was created by a SAML Assertion exists.</b>");
        out.println("<br><br>");
        out.println("<table border=0>");
        out.println("<tr>");
        out.println("<td valign=top><b>Identity Provider: </b></td>");
        out.println("<td>" + responseIDPentityID + "</td>");
        out.println("</tr>");
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
<% } %>
</body>
</html>

