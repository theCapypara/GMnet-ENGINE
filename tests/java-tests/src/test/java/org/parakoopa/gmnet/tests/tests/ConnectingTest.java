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
import static org.parakoopa.gmnet.tests.tests.HelloWorldTest.getProject;
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
 * Here's the exact procedure:
 * - TEST A - testSimpleConnect
 * -- Create server
 * -- Directly connect to server
 * -- Client disconnects
 * - TEST B - testSimpleConnectServerCloses
 * -- Create server
 * -- Directly connect to server
 * -- Server closes
 * - TEST C - testLanConnect
 * -- Create server
 * -- Connect via LAN lobby
 * - TEST D - testWrongIP
 * -- Create server
 * -- Directly connect to server via wrong IP [Must fail!]
 * - TEST E - testNoServerConnect
 * -- DO NOT Create server
 * -- Directly connect to server [Must fail!]
 * - TEST F - testNoServerLanConnect
 * -- DO NOT Create server
 * -- Connect via LAN lobby [Must fail!]
 * 
 * @author Marco Köpcke <parakoopa at live.de>
 */
public class ConnectingTest extends AbstractTest {
    
    protected Logger logger = Logger.getLogger("GLOBAL");
    
    @BeforeClass
    public static void beforeClass() throws Throwable {
        Workspace.setProjectAndConfiguration(getProject(), insertConfiguration());
        setup();
    }
    
    static protected String getProject() {
        return System.getProperty("user.dir")+"/../gamemaker-projects/ConnectionTest.gmx/ConnectionTest.project.gmx";
    }
    
    /**
     * TODO DOC
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
    private Region gameClientRegion;
    private Region gameClientLeftRegion;
    private Region gameClientRightRegion;
    private App gameClient;
    private Region gameServerRegion;
    private Region gameServerLeftRegion;
    private Region gameServerRightRegion;
    private App gameServer;
    
    /**
     * See class documentation.
     * @throws java.lang.InterruptedException
     */
    @Test
    public void testSimpleConnect() throws InterruptedException {
        String logPrefix = "[ConnectionTest] [testSimpleConnect] ";
        logger.info(logPrefix+"STARTING");
        simpleConnect("testSimpleConnect");
        //Client disconnect
        AppHelper.close(gameClient);
        assertNotMatchWait("Client must be dead - There must be NO client box", 
                gameServerRightRegion,
                r("images/all/color_green.png"), 1);
    }
    
    /**
     * See class documentation.
     * @throws java.lang.InterruptedException
     */
    @Test
    public void testSimpleConnectServerCloses() throws InterruptedException {
        String logPrefix = "[ConnectionTest] [testSimpleConnectServerCloses] ";
        logger.info(logPrefix+"STARTING");
        simpleConnect("testSimpleConnectServerCloses");
        //Server close
        AppHelper.close(gameServer);
        assertNotMatchWait("Server must be dead - There must be no client box!", 
                gameClientRightRegion,
                r("images/all/color_green.png"), 1);
        assertNotMatch("Server must be dead - There must be no server box!", 
                gameClientLeftRegion,
                r("images/all/color_green.png"));
        assertMatch("Server must be dead - There must be only red right!", 
                gameClientRightRegion,
                r("images/all/color_red.png"));
        assertMatch("Server must be dead - There must be only red left!", 
                gameClientLeftRegion,
                r("images/all/color_red.png"));
    }
    
    protected void simpleConnect(String logName) throws InterruptedException {
        
        String logPrefix = "[ConnectionTest] ["+logName+"] ";
        Screen s = new Screen();
        this.gameServer = newGameAtPosition(new Point(s.getX()    ,s.getY()));
        this.gameServerRegion = gameServer.window();
        this.gameServerLeftRegion = getLeftRegion(gameServerRegion);
        this.gameServerRightRegion = getRightRegion(gameServerRegion);

        this.gameClient = newGameAtPosition(new Point(s.getX()+500,s.getY()));
        this.gameClientRegion = gameClient.window();
        this.gameClientLeftRegion = getLeftRegion(gameClientRegion);
        this.gameClientRightRegion = getRightRegion(gameClientRegion);

        logger.info(logPrefix+"Start Server");
        gameServerRegion.click();
        s.type("n");
        //A green box on the left indicates that the server was started
        assertMatchWait("Server must be started - There must be a server box", 
                gameServerLeftRegion,
                r("images/all/color_green.png"), 1);
        assertNotMatch("There must be no client box", 
                gameServerRightRegion,
                r("images/all/color_green.png"));

        logger.info(logPrefix+"Connect Client");
        gameClientRegion.click();
        s.type("c");
        assertMatchWait("The client game must ask for IP", 
                s,
                r("images/ConnectingTest/ip.png"), 1);
        s.type("127.0.0.1"+Key.ENTER);
        //Check if connected.
        assertMatchWait("Client: Server must be started - There must be a server box", 
                gameClientLeftRegion,
                r("images/all/color_green.png"), 6);
        assertMatch("Client: Client must be started - There must be a client box", 
                gameClientRightRegion,
                r("images/all/color_green.png"));
        assertMatch("Server: Server must be started", 
                gameServerLeftRegion,
                r("images/all/color_green.png"));
        assertMatch("Server: Client must be started", 
                gameServerRightRegion,
                r("images/all/color_green.png"));
    }
    
    /**
     * See class documentation.
     */
    @Test
    public void testLanConnect() {
        String logPrefix = "[ConnectionTest] [testLanConnect] ";
        logger.info(logPrefix+"STARTING");
    }
    
    /**
     * See class documentation.
     */
    @Test
    public void testWrongIP() {
        String logPrefix = "[ConnectionTest] [testWrongIP] ";
        logger.info(logPrefix+"STARTING");
    }
    
    /**
     * See class documentation.
     */
    @Test
    public void testNoServerConnect() {
        String logPrefix = "[ConnectionTest] [testNoServerConnect] ";
        logger.info(logPrefix+"STARTING");
    }
    
    /**
     * See class documentation.
     */
    @Test
    public void testNoServerLanConnect() {
        String logPrefix = "[ConnectionTest] [testNoServerLanConnect] ";
        logger.info(logPrefix+"STARTING");
    }
    
    protected App newGameAtPosition(Point moveWindowTo) throws InterruptedException {
        App playerApp = newGameInstance();
        playerApp.waitForWindow();
        assertTrue("Game window must be moved", AppHelper.moveApp(playerApp, moveWindowTo));
        return playerApp;
    }

    protected Region getLeftRegion(Region region) {
        return new Region(
                region.getX(), 
                region.getY(), 
                region.getW()/2,
                region.getH()
        );
    }

    protected Region getRightRegion(Region region) {
        return new Region(
                region.getX()+region.getW()/2, 
                region.getY(), 
                region.getW()/2,
                region.getH()
        );
    }
}
