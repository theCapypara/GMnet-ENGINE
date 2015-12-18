/*
 * Copyright (c) 2015 Marco Köpcke <parakoopa at live.de>.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.parakoopa.gmnet.tests;

import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;

/**
 * @todo doc
 */
public class MasterServerHelper {
    protected static Logger logger = Logger.getLogger("GLOBAL");

    public static String getMasterIp() {
        return Workspace.MASTER_IP;
    }

    public static int getMasterPort() {
        return Workspace.MASTER_PORT;
    }

    public static boolean start() {
        URLConnection con;
        try {
            con = new URL(Workspace.MASTER_URL_START).openConnection();
            InputStream in = con.getInputStream();
            String encoding = con.getContentEncoding();
            encoding = encoding == null ? "UTF-8" : encoding;
            String body = IOUtils.toString(in, encoding);
            return body.equals("success.");
        } catch (IOException e) {
            logger.error("[MasterServerHelper] Error while trying to start master server.", e);
            return false;
        }
    }

    public static boolean stop() {
        URLConnection con;
        try {
            con = new URL(Workspace.MASTER_URL_STOP).openConnection();
            InputStream in = con.getInputStream();
            String encoding = con.getContentEncoding();
            encoding = encoding == null ? "UTF-8" : encoding;
            String body = IOUtils.toString(in, encoding);
            return body.equals("success.");
        } catch (IOException e) {
            logger.error("[MasterServerHelper] Error while trying to stop master server.", e);
            return false;
        }
    }

    public static String getPublicIp() throws IOException {
        //URLConnection con = new URL("http://icanhazip.com/").openConnection();
        URLConnection con = new URL("http://95.85.63.183/gmnet/test-api/ip.php").openConnection();
        InputStream in = con.getInputStream();
        String encoding = con.getContentEncoding();
        encoding = encoding == null ? "UTF-8" : encoding;
        return IOUtils.toString(in, encoding);
    }
}
