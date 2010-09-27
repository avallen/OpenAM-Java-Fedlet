package com.hmg.servicecloud.fedlet.servlet;

import com.hmg.servicecloud.fedlet.saml.SAMLRequestSender;
import com.sun.identity.saml2.common.SAML2Exception;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpUtils;
import java.io.IOException;
import java.util.Date;

/**
 * This servlet filter will peridically check the SSO session by sending a SAML Authentication
 * Request with the IsPassive flag set.
 */
public class SAMLSessionCheckFilter implements Filter {

    private static final String LAST_SESSIONCHECK = "LAST_SESSIONCHECK";
    public SAMLRequestSender samlSender;

    public void init(FilterConfig config) throws ServletException {
        samlSender = (SAMLRequestSender) config.getServletContext().getAttribute("samlSender");
        if (this.samlSender == null) {
            throw new ServletException("Unable to find a SAMLRequestSender object in the Servlet context, " +
                    "please make sure to configure the FedletConfigurationServletContextListener class " +
                    "in your web.xml or initialize this object manually.");
        }
    }

    @Override
    public void destroy() {
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {

        final HttpSession session = ((HttpServletRequest) req).getSession();
        long secondsSincelastSessionCheck = getTimeSinceLastSessionCheck(session);

        if (secondsSincelastSessionCheck > 60) {

            final String requestURL = HttpUtils.getRequestURL((HttpServletRequest) req).toString();
            session.setAttribute("FEDLET_RETURN_TO_URL", requestURL);
            updateTimeOfLastSessionCheck(session);
            try {
                samlSender.sendPassiveAuthnRequestReturnTo((HttpServletRequest) req, (HttpServletResponse) resp, requestURL);
            } catch (SAML2Exception e) {
                e.printStackTrace();
                // TODO: what to do here, can we risk throwing an exception, possibly breaking
                // applications that use this filter?
            }
            // the above will cause a redirect, so request processing should stop here.
            return;
        }
        chain.doFilter(req, resp);
    }

    private long getTimeSinceLastSessionCheck(HttpSession session) {
        Long lastSessionCheckTimeUnixSeconds = (Long) session.getAttribute(LAST_SESSIONCHECK);
        long currentTimeUnixEpochSeconds = new Date().getTime() / 1000L;
        if (lastSessionCheckTimeUnixSeconds != null) {
            return currentTimeUnixEpochSeconds - lastSessionCheckTimeUnixSeconds;
        } else {
            // verly long ago ;)
            return currentTimeUnixEpochSeconds;
        }
    }

    private void updateTimeOfLastSessionCheck(HttpSession session) {
        Long lastSessionCheckTimeUnixSeconds = new Date().getTime() / 1000L;
        session.setAttribute(LAST_SESSIONCHECK, lastSessionCheckTimeUnixSeconds);
    }

}
