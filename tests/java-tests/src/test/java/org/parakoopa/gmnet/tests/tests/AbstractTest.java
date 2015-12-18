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

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.rules.TestRule;
import org.junit.runner.Description;
import org.junit.runners.model.Statement;
import org.parakoopa.gmnet.tests.GMnetEngineConfiguration;
import org.parakoopa.gmnet.tests.GameMakerCompiler;
import org.parakoopa.gmnet.tests.RetryableAssertionError;
import org.parakoopa.gmnet.tests.Workspace;
import org.sikuli.script.App;
import org.sikuli.script.FindFailed;
import org.sikuli.script.Region;

import java.io.File;
import java.io.IOException;

import static org.junit.Assert.*;

/**
 * The abstract base class for all GMnet ENGINE tests.
 * @author Marco Köpcke <parakoopa at live.de>
 */
public abstract class AbstractTest {
    
    protected static GameMakerCompiler compiler;
    protected static Logger logger = Logger.getLogger("GLOBAL");


    /**
     * Retry if a RetryableAssertionError occurred.
     */
    public class Retry implements TestRule {
        private int retryCount;

        public Retry(int retryCount) {
            this.retryCount = retryCount;
        }

        public Statement apply(Statement base, Description description) {
            return statement(base, description);
        }

        private Statement statement(final Statement base, final Description description) {
            return new Statement() {
                @Override
                public void evaluate() throws Throwable {
                    Throwable caughtThrowable = null;

                    // implement retry logic here
                    for (int i = 0; i < retryCount; i++) {
                        try {
                            base.evaluate();
                            return;
                        } catch (RetryableAssertionError error) {
                            caughtThrowable = error;
                            System.err.println(description.getDisplayName() + " - retrying : run " + (i+1) + " failed");
                        }
                    }
                    System.err.println(description.getDisplayName() + ": giving up after " + retryCount + " failures");
                    throw caughtThrowable;
                }
            };
        }
    }
    @Rule
    public Retry retry = new Retry(3);
    
    /**
     * Path to test project .project.gmx file
     * @return Returns the path to test project .project.gmx file
     */
    static protected String getProject() {
        throw new AbstractMethodError("This static method needs to be overwritten");
    }
    /**
     * An array of configuration variables to be inserted into the game before 
     * running. They will be added to the end of htme_config in the following
     * format:
     * self.{GMnetEngineConfiguration.VARIABLE} = {GMnetEngineConfiguration.VALUE};
     * As you can see, the value will not be escaped. If you set a string, you
     * need to add quotes to your values.
     * @return The inserted configuration
     */
    static protected GMnetEngineConfiguration[] insertConfiguration() {
        return new GMnetEngineConfiguration[0];
    }
    
    /**
     * Handles compilation of games and general setup.
     * @see HelloWorldTest beforeClass on how to call this.
     * @throws java.lang.Throwable
     */
    protected static void setup() throws Throwable {
        if (!Workspace.IS_PROJECT_SET_UP) {
            throw new UnsupportedOperationException("Your test needs call Workspace.setProjectAndConfiguration in it's beforeClass.");
        }
        Workspace.setup();
        File toCopyProjectFile = new File(Workspace.PROJECT_FILE);
        File toCopyProjectDir = toCopyProjectFile.getParentFile();

        logger.info("[Setup] Copying requested project at "+toCopyProjectFile.toString());
        File testProjectDir = new File(Workspace.DIR+"/test-project/");
        testProjectDir.delete();
        File testProjectProjectFile = new File(testProjectDir+"/"+toCopyProjectFile.getName());

        FileUtils.copyDirectory(toCopyProjectDir, testProjectDir);

        logger.info("[Setup] Running compiler...");
        AbstractTest.compiler = new GameMakerCompiler(testProjectProjectFile.toString(), Workspace.CONFIGURATION_TO_INSERT);

        try {
            compiler.compile();
        } catch (Exception ex) {
            logger.warn("[Setup] Compiler failed. Will retry once more!", ex);
            logger.info("[Setup] Copying requested project at "+toCopyProjectFile.toString());
            // Retry once more
            testProjectDir.delete();
            FileUtils.copyDirectory(toCopyProjectDir, testProjectDir);
            logger.info("[ExternalResource] Running compiler...");
            compiler.compile();
        }
    }
    
    /**
     * Runs before all tests, kills the IDE and then checks if the game exists.
     * If not the test will instantly fail.
     */
    @Before
    public void before() {
        if (!Workspace.IS_SET_UP) {
            throw new UnsupportedOperationException("Your test needs call AbstractTest.setup() in it's beforeClass.");
        }
        logger.info("[AbstractTest] Preparing Test...");
        try {
            compiler.killIDE();
            if (!GameMakerCompiler.gameExeExists()) {
                throw new Exception("Could not run Game");
            }
        } catch (Exception ex) {
            logger.log(Level.ERROR, null, ex);
            fail("We couldn't even start testing. The game didn't compile!");
        }
    }

    /**
     * Runs after all tests and kills all games running.
     */
    @After
    public void after() throws InterruptedException {
        logger.info("[AbstractTest] Cleaning up after test...");
        try {
            compiler.killGame();
            Thread.sleep(500);
        } catch (IOException ex) {
            logger.log(Level.ERROR, "There was an issue cleaning up after the test.", ex);
        }
    }
    
    /**
     * Start a new game instance and get the SikuliX App representation of it.
     * @return SikuliX representation of the game app.
     * @deprecated Use an AbstractGame instead
     */
    protected App newGameInstance() {
        try {
            App gameApp = GameMakerCompiler.runGame();
            Thread.sleep(500);
            assertNotNull("The game must run", gameApp);
            assertTrue("The game must run", gameApp.isValid());
            return gameApp;
        } catch (InterruptedException ex) {
            fail("The thread must not be interrupted");
        }
        return null;
    }
    
    /**
     * Extends the assert methods to provide a simple way of asserting
     * the <code>Region.find(...)</code> of Sikulix.
     * @param <PSI>
     * @param message  The message describing the assert
     * @param region   The region to perform <code>find</code> on
     * @param target   The target that must be found in the region.
     */
    public static <PSI> void assertMatch(String message, Region region, PSI target) {
        boolean s = false;
        try {
            region.find(target);
            s = true;
        } catch (FindFailed ex) {    
            //logger.log(Level.SEVERE, "EXCEPTION during assertMatch.", ex);
        }
        assertTrue(message, s);
    }
    
    
    /**
     * Extends the assert methods to provide a simple way of asserting
     * the <code>Region.wait(...)</code> of Sikulix.
     * @param <PSI>
     * @param message  The message describing the assert
     * @param region   The region to perform <code>wait</code> on
     * @param target   The target that must be found in the region.
     * @param time     Timeout in seconds
     */
    public static <PSI> void assertMatchWait(String message, Region region, PSI target, int time) {
        boolean s = false;
        try {
            region.wait(target, time);
            s = true;
        } catch (FindFailed ex) {    
            //logger.log(Level.SEVERE, "EXCEPTION during assertMatchWait.", ex);
        }
        assertTrue(message, s);
    }
    
    /**
     * Same as assrtMatch but must be negative.
     * @param <PSI>
     * @param message  The message describing the assert
     * @param region   The region to perform <code>find</code> on
     * @param target   The target that must be found in the region.
     */
    public static <PSI> void assertNotMatch(String message, Region region, PSI target) {
        boolean s = false;
        try {
            region.find(target);
        } catch (FindFailed ex) {    
            s = true;
        }
        assertTrue(message, s);
    }
    
    
    /**
     * Same as assrtMatchWait but must be negative.
     * @param <PSI>
     * @param message  The message describing the assert
     * @param region   The region to perform <code>wait</code> on
     * @param target   The target that must be found in the region.
     * @param time     Timeout in seconds
     */
    public static <PSI> void assertNotMatchWait(String message, Region region, PSI target, int time) {
        boolean s = false;
        s = region.waitVanish(target, time);
        assertTrue(message, s);
    }
}
