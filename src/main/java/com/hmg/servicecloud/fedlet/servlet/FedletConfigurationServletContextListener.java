package com.hmg.servicecloud.fedlet.servlet;

import com.hmg.servicecloud.fedlet.saml.SAMLRequestSender;
import com.hmg.servicecloud.fedlet.util.FedletConfiguration;
import com.sun.identity.saml2.meta.SAML2MetaException;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * @author Andreas Vallen
 */
public class FedletConfigurationServletContextListener implements ServletContextListener {

    public static String FEDLET_CONFIG_ATTR = "fedletConfig";
    private static final String SAML_REQUEST_SENDER = "samlSender";
    private Logger logger = Logger.getLogger(this.getClass().getName());

    public void contextInitialized(ServletContextEvent sce) {

        ServletContext context = sce.getServletContext();
        try {
            FedletConfiguration fedletConfiguration = FedletConfiguration.createFromMetaData(context.getContextPath());
            context.setAttribute(FEDLET_CONFIG_ATTR, fedletConfiguration);

            SAMLRequestSender samlRequestSender = new SAMLRequestSender(fedletConfiguration);
            context.setAttribute(SAML_REQUEST_SENDER, samlRequestSender);
        } catch (SAML2MetaException e) {
            logger.log(Level.SEVERE, "Error while loading fedlet's configuration: " + e.getMessage(), e);
        }
    }

    public void contextDestroyed(ServletContextEvent sce) {
    }
}
