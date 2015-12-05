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
import org.junit.Test;
import org.parakoopa.gmnet.tests.AppHelper;
import org.parakoopa.gmnet.tests.GMnetEngineConfiguration;
import org.sikuli.script.App;
import org.sikuli.script.FindFailed;
import org.sikuli.script.Key;
import org.sikuli.script.Region;
import org.sikuli.script.Screen;

/**
 * Basic test to test GMnet ENGINE compilation and testing functionality.
 * 
 * This test will compile a simple GameMaker game. This game has to display
 * the message 'Hello World!' (inserted into htme_config 
 * by <code>insertConfiguration</code>).
 * After that it will show a simple 4-colored background. This background will
 * be checked if it matches the expectations.
 * Then the test will be performed again for a second game instance.
 * Both instances of the game will also be moved across the screen to test the
 * <code>AppHelper</code>.
 * 
 * @author Marco Köpcke <parakoopa at live.de>
 */
public class HelloWorldTest extends AbstractTest {
    
    protected Logger logger = Logger.getLogger("GLOBAL");
    
    @Override
    protected String getProject() {
        return System.getProperty("user.dir")+"/../gamemaker-projects/HelloWorldTest.gmx/HelloWorldTest.project.gmx";
    }
    
    /**
     * Insert a show_message command to display the 'Hello World!' message.
     * @return The inserted configuration
     */
    @Override
    protected GMnetEngineConfiguration[] insertConfiguration() {
        GMnetEngineConfiguration[] gec = new GMnetEngineConfiguration[1];
        gec[0] = new GMnetEngineConfiguration("helloWorld","show_message('Hello World!')");
        return gec;
    }
    
    /**
     * Runs the test.
     * See class documentation.
     */
    @Test
    public void test() {
        try {
            logger.info("[HelloWorldTest] STARTING");
            Screen s = new Screen();
            logger.info("[HelloWorldTest] Run test for player1...");
            testSinglePlayer(1, new Point(s.getX(),s.getY()));
            logger.info("[HelloWorldTest] Run test for player2...");
            testSinglePlayer(2, new Point(s.getX()+500,s.getY()));
            logger.info("[HelloWorldTest] Done!");
        } catch (InterruptedException ex) {
            logger.log(Level.ERROR, null, ex);
            fail("Test was interrupted:");
        }
    }
    
    /**
     * Starts a single game, moves it's window the provided position and performs
     * the test on it.
     * @param playernum
     * @param moveWindowTo
     * @throws InterruptedException 
     */
    public void testSinglePlayer(int playernum, Point moveWindowTo) throws InterruptedException {;
        App playerApp = newGameInstance();
        Screen s = new Screen();
        
        logger.info("[HelloWorldTest] ["+playernum+"] Test HelloWorld message...");
        
        assertMatchWait("Player "+playernum+": HelloWorld message must be displayed.",
                s, "images/HelloWorldTest/helloworld.png", 3);
        try {
            s.click("images/HelloWorldTest/helloworld.png");
            s.type(Key.ENTER);
        } catch (FindFailed ex) {
            fail("Player "+playernum+": HelloWorld message must be displayed.");
        }
        Thread.sleep(200);
        logger.info("[HelloWorldTest] ["+playernum+"] Test window moving...");
        assertTrue("Player "+playernum+":Window must be moved", AppHelper.moveApp(playerApp, moveWindowTo));
        
        logger.info("[HelloWorldTest] ["+playernum+"] Test pattern matching...");
        Region playerRegion = playerApp.window();
        
        Region upLeftRegion = new Region(
                playerRegion.getX(), 
                playerRegion.getY(), 
                playerRegion.getW()/2,
                playerRegion.getH()/2
        );
        assertMatch("Player "+playernum+": The upper left corner must be green.", 
                upLeftRegion, 
                "images/all/color_green.png");
        
        Region upRightRegion = new Region(
                playerRegion.getX()+playerRegion.getW()/2, 
                playerRegion.getY(), 
                playerRegion.getW()/2,
                playerRegion.getH()/2
        );
        assertMatch("Player "+playernum+": The upper right corner must be yellow.", 
                upRightRegion, 
                "images/all/color_yellow.png");
        
        Region downLeftRegion = new Region(
                playerRegion.getX(), 
                playerRegion.getY()+playerRegion.getW()/2, 
                playerRegion.getW()/2,
                playerRegion.getH()/2
        );
        assertMatch("Player "+playernum+": The lower left corner must be blue.", 
                downLeftRegion, 
                "images/all/color_blue.png");
        
        Region downRightRegion = new Region(
                playerRegion.getX()+playerRegion.getW()/2, 
                playerRegion.getY()+playerRegion.getW()/2, 
                playerRegion.getW()/2,
                playerRegion.getH()/2
        );
        assertMatch("Player "+playernum+": The lower right corner must be red.", 
                downRightRegion, 
                "images/all/color_red.png");
        
    }
}
