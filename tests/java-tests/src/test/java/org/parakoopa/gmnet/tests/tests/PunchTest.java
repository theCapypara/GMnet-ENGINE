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
package org.parakoopa.gmnet.tests.tests;

import org.apache.log4j.Logger;
import org.junit.After;
import org.junit.BeforeClass;
import org.junit.Test;
import org.parakoopa.gmnet.tests.FirewallHelper;
import org.parakoopa.gmnet.tests.GMnetEngineConfiguration;
import org.parakoopa.gmnet.tests.MasterServerHelper;
import org.parakoopa.gmnet.tests.Workspace;
import org.parakoopa.gmnet.tests.games.ClientGame;
import org.parakoopa.gmnet.tests.games.ServerGame;
import org.sikuli.script.Screen;

import java.awt.*;
import java.io.IOException;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;
import static org.parakoopa.gmnet.tests.Workspace.r;

/**
 * Test to check making connections with PUNCH.
 * 
 * This test will first try to connect a server to a client (locally),
 * after that it will try to use the LAN lobby to connect.
 *
 * == INHERITED from ConnectionTest ==
 * All tests of ConnectingTest will be repeated using GMnet PUNCH instead of builtin connect.
 * -testSimpleConnect
 * -- Create server
 * -- Connect via localhost - should fallback to directconnect
 * -- Client disconnects
 * -testSimpleConnectServerCloses
 * -- Create server
 * -- Connect via localhost - should fallback to directconnect
 * -- Server closes
 * -testLanConnect
 * -- (See ConnectingTest)
 * -testWrongIP
 * -- (See ConnectingTest)
 * -testNoServerConnect
 * -- (See ConnectingTest)
 * -testNoServerLanConnect
 * -- (See ConnectingTest)
 *
 * For new tests see test methods in this class.
 *
 * @todo Add tests for lobby filters and other lobby functions
 * @author Marco Köpcke <parakoopa at live.de>
 */
public class PunchTest extends ConnectingTest {

    protected Logger logger = Logger.getLogger("GLOBAL");
    protected Screen s;

    @BeforeClass
    public static void beforeClass() throws Throwable {
        // Increase Timeout for tests where the master server doesn't exist
        Workspace.ConnectTimeoutTime = 7;
        Workspace.setProjectAndConfiguration(getProject(), insertConfiguration());
        setup();
    }

    static protected String getProject() {
        return System.getProperty("user.dir")+"/../gamemaker-projects/PunchTest.gmx/PunchTest.project.gmx";
    }

    public PunchTest() {
        s = new Screen();
    }

    /**
     * @return The inserted configuration
     */
    static protected GMnetEngineConfiguration[] insertConfiguration() {
        GMnetEngineConfiguration[] gec = new GMnetEngineConfiguration[8];
        gec[0] = new GMnetEngineConfiguration("debugoverlay","false");
        gec[1] = new GMnetEngineConfiguration("use_udphp","true");
        gec[2] = new GMnetEngineConfiguration("udphp_master_ip","\""+ MasterServerHelper.getMasterIp()+"\"");
        gec[3] = new GMnetEngineConfiguration("udphp_master_port",String.valueOf(MasterServerHelper.getMasterPort()));
        gec[4] = new GMnetEngineConfiguration("udphp_rctintv","30*room_speed");
        gec[5] = new GMnetEngineConfiguration("global_timeout","5*room_speed");
        gec[6] = new GMnetEngineConfiguration("lan_interval","1*room_speed");
        gec[7] = new GMnetEngineConfiguration("gamename","\"gmnet_130_punch_test\"");
        return gec;
    }

    /**
     * Test procedure:
     * -- Start GMnet PUNCH.GATE master server
     * -- Create server
     * -- Start client
     * -- Connect client directly via public IP
     * -- Client must be connected
     */
    @Test
    public void punchConnectUsingIp() throws InterruptedException, IOException {
        String logPrefix = "[PunchTest] [punchConnectUsingIp] ";
        logger.info(logPrefix+"STARTING");

        assertTrue("The master server must start", MasterServerHelper.start());

        logger.info(logPrefix+"Start Server");
        ServerGame gameServer = new ServerGame(new Point(s.getX(), s.getY()));
        gameServer.start();

        logger.info(logPrefix+"Connect Client");
        ClientGame gameClient = new ClientGame(new Point(s.getX() + 500, s.getY()));
        gameClient.connect(MasterServerHelper.getPublicIp());

        assertConnected(gameClient);
        assertConnected(gameServer);
    }

    /**
     * Test procedure:
     * -- Start GMnet PUNCH.GATE master server
     * -- Create server
     * -- Start client
     * -- Connect client via online Lobby
     * -- Client must be connected
     */
    @Test
    public void punchConnectUsingOnlineLobby() throws InterruptedException {
        String logPrefix = "[PunchTest] [punchConnectUsingOnlineLobby] ";
        logger.info(logPrefix+"STARTING");

        assertTrue("The master server must start", MasterServerHelper.start());

        logger.info(logPrefix+"Start Server");
        ServerGame gameServer = new ServerGame(new Point(s.getX(), s.getY()));
        gameServer.start();

        logger.info(logPrefix+"Connect Client");
        ClientGame gameClient = new ClientGame(new Point(s.getX() + 500, s.getY()));
        gameClient.connectOnline();

        assertConnected(gameClient);
        assertConnected(gameServer);
    }

    /**
     * Test procedure:
     * -- Start GMnet PUNCH.GATE master server
     * -- Create server
     * -- Configure firewall to reject public traffic on game port
     * -- Start client
     * -- Connect client directly via public IP
     * -- Client must NOT be connected
     */
    @Test
    public void punchConnectRestrictiveNat() throws InterruptedException, IOException {
        fail("Test not added yet.");
        String logPrefix = "[PunchTest] [punchConnectRestrictiveNat] ";
        logger.info(logPrefix+"STARTING");

        assertTrue("The firewall must be set to be restrictive", FirewallHelper.restrict());
        assertTrue("The master server must start", MasterServerHelper.start());

        logger.info(logPrefix+"Start Server");
        ServerGame gameServer = new ServerGame(new Point(s.getX(), s.getY()));
        gameServer.start();

        logger.info(logPrefix+"Connect Client");
        ClientGame gameClient = new ClientGame(new Point(s.getX() + 500, s.getY()));
        gameClient.connect(MasterServerHelper.getPublicIp());

        assertConnected(gameClient);
        assertConnected(gameServer);
    }

    /**
     * Test procedure:
     * -- Start GMnet PUNCH.GATE master server
     * -- Create server
     * -- Kill GMnet PUNCH.GATE
     * -- Wait max. 1 minute for the game server to indicate it lost connecting with GMnet PUNCH.GATE
     * -- Start GMnet PUNCH.GATE
     * -- Wait max. 1 minute for the game server to indicate it is connected again with GMnet PUNCH.GATE
     * -- Start client
     * -- Connect client directly via public IP
     * -- Client must be connected
     */
    @Test
    public void punchTestReconnect() throws InterruptedException, IOException {
        String logPrefix = "[PunchTest] [punchTestReconnect] ";
        logger.info(logPrefix+"STARTING");

        assertTrue("The master server must start", MasterServerHelper.start());

        logger.info(logPrefix+"Start Server");
        ServerGame gameServer = new ServerGame(new Point(s.getX(), s.getY()));
        gameServer.start();

        assertTrue("The master server must stop", MasterServerHelper.stop());
        assertMatchWait("The master server must be gone, server box needs to be yellow",
                gameServer.getRightRegion(),
                r("images/all/color_yellow.png"), 60);

        assertTrue("The master server must start", MasterServerHelper.start());
        assertNotMatchWait("The master server must be connected, server box needs to be green",
                gameServer.getRightRegion(),
                r("images/all/color_yellow.png"), 60);

        logger.info(logPrefix+"Connect Client");
        ClientGame gameClient = new ClientGame(new Point(s.getX() + 500, s.getY()));
        gameClient.connect(MasterServerHelper.getPublicIp());

        assertConnected(gameClient);
        assertConnected(gameServer);
    }

    /**
     * Kills the master server before running the test.
     * Reset restrictive firewall settings
     */
    @After
    @Override
    public void before() {
        super.before();
        logger.info("[PunchTest] Killing master server...");
        assertTrue("Couldn't stop master server before running tests",MasterServerHelper.stop());
        /*logger.info("[PunchTest] Reseting firewall...");
        assertTrue("Couldn't reset firewall before running test",FirewallHelper.reset());*/
    }
}
