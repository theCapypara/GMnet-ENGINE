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

import java.awt.Point;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import static org.junit.Assert.*;
import org.junit.BeforeClass;
import org.junit.Test;
import org.parakoopa.gmnet.tests.AppHelper;
import org.parakoopa.gmnet.tests.GMnetEngineConfiguration;
import org.parakoopa.gmnet.tests.Workspace;

import static org.parakoopa.gmnet.tests.Workspace.r;
import static org.parakoopa.gmnet.tests.tests.HelloWorldTest.getProject;

import org.parakoopa.gmnet.tests.games.AbstractGame;
import org.parakoopa.gmnet.tests.games.ClientGame;
import org.parakoopa.gmnet.tests.games.ServerGame;
import org.sikuli.script.App;
import org.sikuli.script.FindFailed;
import org.sikuli.script.Key;
import org.sikuli.script.Region;
import org.sikuli.script.Screen;

/**
 * Test to check making connections without PUNCH.
 * 
 * This test will first try to connect a server to a client (locally),
 * after that it will try to use the LAN lobby to connect.
 * 
 * @author Marco Köpcke <parakoopa at live.de>
 */
public class ConnectingTest extends AbstractTest {
    
    protected Logger logger = Logger.getLogger("GLOBAL");
    protected Screen s;
    
    @BeforeClass
    public static void beforeClass() throws Throwable {
        Workspace.setProjectAndConfiguration(getProject(), insertConfiguration());
        setup();
    }
    
    static protected String getProject() {
        return System.getProperty("user.dir")+"/../gamemaker-projects/ConnectionTest.gmx/ConnectionTest.project.gmx";
    }

    public ConnectingTest() {
        s = new Screen();
    }

    /**
     * Insert configuration. PUNCH is disabled.
     * @return The inserted configuration
     */
    static protected GMnetEngineConfiguration[] insertConfiguration() {
        GMnetEngineConfiguration[] gec = new GMnetEngineConfiguration[5];
        gec[0] = new GMnetEngineConfiguration("debugoverlay","false");
        gec[1] = new GMnetEngineConfiguration("use_udphp","false");
        gec[2] = new GMnetEngineConfiguration("global_timeout","5*room_speed");
        gec[3] = new GMnetEngineConfiguration("lan_interval","1*room_speed");
        gec[4] = new GMnetEngineConfiguration("gamename","\"gmnet_130_connecting_test\"");        
        return gec;
    }
    
    /**
     * Test procedure:
     * -- Create server
     * -- Directly connect to server
     * -- Client disconnects
     * @throws java.lang.InterruptedException
     */
    @Test
    public void testSimpleConnect() throws InterruptedException {
        String logPrefix = "[ConnectionTest] [testSimpleConnect] ";
        logger.info(logPrefix+"STARTING");

        logger.info(logPrefix+"Start Server");
        ServerGame gameServer = new ServerGame(new Point(s.getX(), s.getY()));
        gameServer.start();

        logger.info(logPrefix+"Connect Client");
        ClientGame gameClient = new ClientGame(new Point(s.getX() + 500, s.getY()));
        gameClient.connect("127.0.0.1");

        assertConnected(gameClient);
        assertConnected(gameServer);
        //Client disconnect
        gameClient.close();
        assertNotMatchWait("Client must be dead - There must be NO client box", 
                gameServer.getRightRegion(),
                r("images/all/color_green.png"), 1);
    }

    /**
     * Test procedure:
     * -- Create server
     * -- Directly connect to server
     * -- Server closes
     * @throws java.lang.InterruptedException
     */
    @Test
    public void testSimpleConnectServerCloses() throws InterruptedException {
        String logPrefix = "[ConnectionTest] [testSimpleConnectServerCloses] ";
        logger.info(logPrefix+"STARTING");

        logger.info(logPrefix+"Start Server");
        ServerGame gameServer = new ServerGame(new Point(s.getX(), s.getY()));
        gameServer.start();

        logger.info(logPrefix+"Connect Client");
        ClientGame gameClient = new ClientGame(new Point(s.getX() + 500, s.getY()));
        gameClient.connect("127.0.0.1");

        assertConnected(gameClient);
        assertConnected(gameServer);
        //Server close
        gameServer.close();
        assertNotMatchWait("Server must be dead - There must be no client box!",
                gameServer.getRightRegion(),
                r("images/all/color_green.png"), 1);
        assertNotMatch("Server must be dead - There must be no server box!",
                gameServer.getLeftRegion(),
                r("images/all/color_green.png"));
        gameClient.assertError("Server must be dead");
    }

    /**
     * Test procedure:
     * -- Create server
     * -- Connect via LAN lobby
     */
    @Test
    public void testLanConnect() throws InterruptedException {
        String logPrefix = "[ConnectionTest] [testLanConnect] ";
        logger.info(logPrefix+"STARTING");

        logger.info(logPrefix+"Start Server");
        ServerGame gameServer = new ServerGame(new Point(s.getX(), s.getY()));
        gameServer.start();

        logger.info(logPrefix+"Connect Client via LAN lobby");
        ClientGame gameClient = new ClientGame(new Point(s.getX() + 500, s.getY()));
        gameClient.connectLan();

        assertConnected(gameClient);
        assertConnected(gameServer);
    }

    /**
     * Test procedure:
     * -- Create server
     * -- Directly connect to server via wrong IP [Must fail!]
     */
    @Test
    public void testWrongIP() throws InterruptedException {
        String logPrefix = "[ConnectionTest] [testWrongIP] ";
        logger.info(logPrefix+"STARTING");

        logger.info(logPrefix+"Start Server");
        ServerGame gameServer = new ServerGame(new Point(s.getX(), s.getY()));
        gameServer.start();

        logger.info(logPrefix+"Connect Client to wrong ip");
        ClientGame gameClient = new ClientGame(new Point(s.getX() + 500, s.getY()));
        gameClient.connect("127.0.0.2");

        gameClient.assertError("Must not be connected");
    }
    
    /**
     * Test procedure:
     * -- DO NOT Create server
     * -- Directly connect to server [Must fail!]
     */
    @Test
    public void testNoServerConnect() throws InterruptedException {
        String logPrefix = "[ConnectionTest] [testNoServerConnect] ";
        logger.info(logPrefix+"STARTING");

        logger.info(logPrefix+"Connect Client");
        ClientGame gameClient = new ClientGame(new Point(s.getX() + 500, s.getY()));
        gameClient.connect("127.0.0.1");

        gameClient.assertError("Must not be connected");
    }

    /**
     * Test procedure:
     * -- DO NOT Create server
     * -- Connect via LAN lobby [Must fail!]
     */
    @Test
    public void testNoServerLanConnect() throws InterruptedException {
        String logPrefix = "[ConnectionTest] [testNoServerLanConnect] ";
        logger.info(logPrefix+"STARTING");

        logger.info(logPrefix+"Connect Client via LAN lobby");
        ClientGame gameClient = new ClientGame(new Point(s.getX() + 500, s.getY()));
        gameClient.connectLan();

        Thread.sleep(6000);
        assertMatch("Client: Must still be in LAN lobby - There Must be aqua right!",
                gameClient.getRightRegion(),
                r("images/all/color_aqua.png"));
        assertMatch("Client: Must still be in LAN lobby - There must be aqua left!",
                gameClient.getLeftRegion(),
                r("images/all/color_aqua.png"));
    }

    protected void assertConnected(AbstractGame game) {
        assertMatchWait(game.getClass().getName()+": Server Box must exist",
                game.getLeftRegion(),
                r("images/all/color_green.png"), Workspace.ConnectTimeoutTime);
        assertMatch(game.getClass().getName()+": Client Box must exist",
                game.getRightRegion(),
                r("images/all/color_green.png"));
    }
}
