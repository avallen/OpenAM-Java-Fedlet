package com.hmg.servicecloud.fedlet.util;

/**
 *
 */
public class FedletConstants {

    /**
     * Session key for storing the URL where to return to after processing
     * of some SAML message.
     */
    public static final String FEDLET_RETURN_TO_URL_ATTR = "FEDLET_RETURN_TO_URL_ATTR";

    /**
     * Session key for storing the {@link com.hmg.servicecloud.fedlet.saml.SAMLResponse}
     * object created after successful SAML Single Login.
     */
    public static final String SAML_RESPONSE_ATTR = "SAML_RESPONSE_ATTR";
}
