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

import org.sikuli.script.Key;

import java.awt.*;

import static org.parakoopa.gmnet.tests.Workspace.r;
import static org.parakoopa.gmnet.tests.tests.AbstractTest.assertMatch;
import static org.parakoopa.gmnet.tests.tests.AbstractTest.assertMatchWait;

/**
 * This class represents a GameMaker game instance.
 * More specifically, this represents a client created using
 * a GMnet test project.
 *
 * It includes methods to perform tasks and get information,
 * that is common across all Game Maker GMnet test projects.
 */
public class ClientGame extends AbstractGame {
    public ClientGame(Point moveWindowTo) throws InterruptedException {
        super(moveWindowTo);
    }

    @Override
    public void assertConnected() {
        assertMatchWait("Client: Server must be started - There must be a server box",
                getLeftRegion(),
                r("images/all/color_green.png"), 6);
        assertMatch("Client: Client must be started - There must be a client box",
                getRightRegion(),
                r("images/all/color_green.png"));
    }

    public void connect(String ip) {
        region.click();
        s.type("c");
        assertMatchWait("The client game must ask for IP",
                s,
                r("images/ConnectingTest/ip.png"), 1);
        s.type(ip+ Key.ENTER);
    }

    public void connectLan() {
        region.click();
        s.type("l");
    }
}
