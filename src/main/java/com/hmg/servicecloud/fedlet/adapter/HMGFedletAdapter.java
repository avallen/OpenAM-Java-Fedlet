package com.hmg.servicecloud.fedlet.adapter;

import com.sun.identity.saml2.assertion.NameID;
import com.sun.identity.saml2.common.SAML2Exception;
import com.sun.identity.saml2.plugins.DefaultFedletAdapter;
import com.sun.identity.saml2.protocol.LogoutRequest;
import com.sun.identity.saml2.protocol.LogoutResponse;
import com.sun.identity.shared.encode.URLEncDec;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * This FedletAdapter implementation is used for processing incoming SLO requests.
 * <p/>
 *
 * @author Andreas Vallen
 */
public class HMGFedletAdapter extends DefaultFedletAdapter {

    private UserSessionAdapter userSessionAdapter = new SimpleUserSessionAdapter();

    @Override
    public boolean doFedletSLO(HttpServletRequest request, HttpServletResponse response, LogoutRequest logoutReq, String hostedEntityID, String idpEntityID, List siList, String nameIDValue, String binding) throws SAML2Exception {
        super.doFedletSLO(request, response, logoutReq, hostedEntityID, idpEntityID, siList, nameIDValue, binding);
        invalidateSessionForSamlSessionIndex(siList);
        return true;
    }

    /**
     * This method is invoked by the fedlet framework when the fedlet has initiated
     * the SLO reqeust and gets a successful SLO response.
     */
    @Override
    public void onFedletSLOFailure(HttpServletRequest request, HttpServletResponse response, LogoutRequest logoutReq, LogoutResponse logoutRes, String hostedEntityID, String idpEntityID, String binding) throws SAML2Exception {
        super.onFedletSLOSuccess(request, response, logoutReq, logoutRes, hostedEntityID, idpEntityID, binding);
    }

    /**
     * this method is invoked by the fedlet framework when the fedlet has initiated
     * the SLO reqeust and gets a successful SLO response.
     *
     * @throws SAML2Exception
     */
    @Override
    public void onFedletSLOSuccess(HttpServletRequest request, HttpServletResponse response, LogoutRequest logoutReq, LogoutResponse logoutRes, String hostedEntityID, String idpEntityID, String binding) throws SAML2Exception {
        super.onFedletSLOSuccess(request, response, logoutReq, logoutRes, hostedEntityID, idpEntityID, binding);
        if (logoutReq != null) {
            List siList = logoutReq.getSessionIndex();
            invalidateSessionForSamlSessionIndex(siList);
        }
    }

    private void invalidateSessionForSamlSessionIndex(List siList) {
        if ((siList != null) && (!siList.isEmpty())) {
            String sessionIndex = (String) siList.get(0);
            if (sessionIndex != null) {
                userSessionAdapter.invalidateSessionForSamlSessionIndex(sessionIndex);
            }
        }
    }
}
