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
package org.parakoopa.gmnet.tests.games;

import org.parakoopa.gmnet.tests.AppHelper;
import org.parakoopa.gmnet.tests.GameMakerCompiler;
import org.sikuli.script.App;
import org.sikuli.script.Region;
import org.sikuli.script.Screen;

import java.awt.*;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;
import static org.parakoopa.gmnet.tests.Workspace.r;
import static org.parakoopa.gmnet.tests.tests.AbstractTest.assertMatch;
import static org.parakoopa.gmnet.tests.tests.AbstractTest.assertMatchWait;

/**
 * This class represents a GameMaker game instance.
 * It includes methods to perform tasks and get information,
 * that is common across all Game Maker GMnet test projects.
 */
public abstract class AbstractGame {


    protected App app = null;
    protected Region region = null;
    protected Screen s = null;

    public AbstractGame() {
        s = new Screen();
        try {
            app = GameMakerCompiler.runGame();
            Thread.sleep(500);
            assertNotNull("The game must run", app);
            assertTrue("The game must run", app.isValid());
            app.waitForWindow();
            region = app.window();
        } catch (InterruptedException ex) {
            fail("The thread must not be interrupted");
        }
    }

    public AbstractGame(Point moveWindowTo) throws InterruptedException {
        this();
        assertTrue("Game window must be moved", AppHelper.moveApp(app, moveWindowTo));
        region = app.window();
    }

    public App getApp() {
        return app;
    }

    public Region getRegion() {
        return region;
    }

    public Region getLeftRegion() {
        return new Region(
                region.getX(),
                region.getY(),
                region.getW()/2,
                region.getH()
        );
    }

    public Region getRightRegion() {
        return new Region(
                region.getX()+region.getW()/2,
                region.getY(),
                region.getW()/2,
                region.getH()
        );
    }

    public boolean close() {
        return AppHelper.close(app);
    }

    public abstract void assertConnected();

    public void assertError(String message) {
        assertMatchWait(getClass().getName()+": "+message+" - There must be only red right!",
                getRightRegion(),
                r("images/all/color_red.png"), 6);
        assertMatch(getClass().getName()+": "+message+" - There must be only red left!",
                getLeftRegion(),
                r("images/all/color_red.png"));
    };
}
