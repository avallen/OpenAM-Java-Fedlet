package com.hmg.servicecloud.fedlet.util;

import com.sun.identity.saml2.common.SAML2Exception;
import com.sun.identity.saml2.meta.SAML2MetaException;

import javax.servlet.ServletContext;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

/**
 * @author Andreas Vallen
 */
public class FedletUtils {

    private ServletContext servletContext;
    private String fedletHomeDir;

    public FedletUtils(ServletContext servletContext) throws SAML2MetaException {
        this.servletContext = servletContext;
    }

    /**
     * @return the directory name where the fedlet expects to find its configuration property files.
     */
    public String getFedletConfigDir() {
        if (this.fedletHomeDir != null) {
            return fedletHomeDir;
        }
        this.fedletHomeDir = System.getProperty("com.sun.identity.fedlet.home");
        if ((fedletHomeDir == null) || (fedletHomeDir.trim().length() == 0)) {
            if (System.getProperty("user.home").equals(File.separator)) {
                fedletHomeDir = File.separator + "fedlet";
            } else {
                fedletHomeDir = System.getProperty("user.home") +
                        File.separator + "fedlet";
            }
        }
        return fedletHomeDir;
    }

    public boolean hasConfigFileIncludedInWar() {
        // check if this WAR contain Fedlet configuration
        if (this.servletContext.getResourceAsStream("/conf/FederationConfig.properties") != null)
            return true;
        else
            return false;
    }

    public boolean fedletConfigurationExists() {
        File fedletConfigDir = new File(this.getFedletConfigDir());
        File federationConfigFile = new File(this.getFedletConfigDir() + File.separator +
                "FederationConfig.properties");
        return fedletConfigDir.exists() && fedletConfigDir.isDirectory() && federationConfigFile.exists();
    }

    public void copyConfigurationFilesToDir() throws SAML2Exception {

        String fedletHomeDir = getFedletConfigDir();

        // copy all files under conf to fedletHomeDir
        String[] files = new String[]{
                "FederationConfig.properties",
                "idp.xml",
                "idp-extended.xml",
                "sp.xml",
                "sp-extended.xml",
                "fedlet.cot"};
        File dir = new File(fedletHomeDir);
        if (!dir.exists()) {
            if (!dir.mkdirs()) {
                throw new SAML2Exception("Failed to create Fedlet " +
                        "configuration home directory " + fedletHomeDir);
            }
        } else if (dir.isFile()) {
            throw new SAML2Exception("Fedlet configuration home " +
                    fedletHomeDir + " is a pre-existing file. <br>Please " +
                    "remove the file and try again.");
        }

        for (int i = 0; i < files.length; i++) {
            String source = "/conf/" + files[i];
            String dest = dir.getPath() + File.separator + files[i];
            FileOutputStream fos = null;
            InputStream src = null;
            try {
                src = this.servletContext.getResourceAsStream(source);
                if (src != null) {
                    fos = new FileOutputStream(dest);
                    int length = 0;
                    byte[] bytes = new byte[1024];
                    while ((length = src.read(bytes)) != -1) {
                        fos.write(bytes, 0, length);
                    }
                } else {
                    throw new SAML2Exception("File " + source +
                            " could not be found in fedlet.war");
                }
            } catch (IOException e) {
                throw new SAML2Exception(e.getMessage());
            } finally {
                try {
                    if (fos != null) {
                        fos.close();
                    }
                    if (src != null) {
                        src.close();
                    }
                } catch (IOException ex) {
                    //ignore
                }
            }
        }
    }
}
