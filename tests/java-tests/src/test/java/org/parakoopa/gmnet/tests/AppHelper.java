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

import java.awt.Point;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.sikuli.script.App;
import org.sikuli.script.FindFailed;
import org.sikuli.script.Key;
import org.sikuli.script.Location;
import org.sikuli.script.Region;
import org.sikuli.script.Screen;

/**
 * Helper for <code>org.sikuli.script.App</code>
 * @author Marco Köpcke <parakoopa at live.de>
 */
public class AppHelper {
    protected static Logger logger = Logger.getLogger("GLOBAL");
    /**
     * Moves the main window of specified app to the given location.
     * 
     * @param appToMove   App object to move
     * @param newPosition The position the app should be moved
     * @return Whether the movement was successfull
     */
    public static boolean moveApp(App appToMove, Point newPosition) {
        Region r = appToMove.window();
        Screen s = new Screen();
        try {
            s.rightClick(new Location(r.getX()+r.getW()/2,r.getY()+5));
            s.type(Key.DOWN);
            s.type(Key.DOWN);
            s.type(Key.ENTER);
            s.type(Key.UP);
            s.type(Key.DOWN);
            //Must add half width because Windows will position at center of click
            s.click(new Location(newPosition.getX()+r.getW()/2,newPosition.getY()));
            Region newR = appToMove.window();
            if (Math.abs(newR.getX()-newPosition.getX()) > 10 ||
                    Math.abs(newR.getY()-newPosition.getY()) > 15) {
            logger.error("[AppHelper] [ERROR] New window position is not the same as requested.");
                return false;
            }
        } catch (FindFailed ex) {
            logger.log(Level.ERROR, null, ex);
            return false;
        }
    return true;
    }

    /**
     * Closes an app using the titlebar, a rightclick and choosing "Close".
     * This is more useful with Game Maker games, since calling
     * <code>appToClose.close()</code> won't trigger any game "Destroy" events.
     * @param appToClose 
     */
    public static boolean close(App appToClose) {
        Region r = appToClose.window();
        Screen s = new Screen();
        try {
            s.rightClick(new Location(r.getX()+r.getW()/2,r.getY()+5));
            s.type(Key.UP);
            s.type(Key.ENTER);
            return true;
        } catch (FindFailed ex) {
            logger.log(Level.ERROR, null, ex);
            return false;
        }
    }
}
