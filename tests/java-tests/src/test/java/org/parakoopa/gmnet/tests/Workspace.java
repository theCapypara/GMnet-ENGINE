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

import java.net.URL;

/**
 * Constants for path configuration.
 * @author Marco Köpcke <parakoopa at live.de>
 */
public class Workspace {
    /**
     * The directory all files produced by the compiler will be put in.
     */
    public static String DIR;
    /**
     * Path to GMnet ENGINE that is going to be tested.
     */
    public static String GMNET_DIR;
    /**
     * Path to GMnet ENGINE project file that is going to be tested.
     */
    public static String GMNET_PROJECT_FILE;
    /**
     * Path that the compiled test project will be stored in.
     */
    public static String COMPILED_GAME_DIR;
    
    /**
     * Path to GameMaker installation.
     */
    public static String GAME_MAKER_PATH;
    /**
     * Name of GameMaker executeable.
     */
    public static String GAME_MAKER_EXE;
    
    public static boolean IS_PROJECT_SET_UP = false;
    public static boolean IS_SET_UP = false;

    /**
     * The ip of the master server to use for PUNCH
     */
    public final static String MASTER_IP = "95.85.63.183";
    /**
     * The port of the master server
     */
    public final static int MASTER_PORT = 6520;
    /**
     * The HTTP call that starts the GMnet GATE.PUNCH master server
     */
    public final static String MASTER_URL_START = "http://95.85.63.183/gmnet/test-api/start.php";
    /**
     * The HTTP call that stops the GMnet GATE.PUNCH master server
     */
    public final static String MASTER_URL_STOP = "http://95.85.63.183/gmnet/test-api/stop.php";
    
    /**
     * Path to project to compile.
     * @see HelloWorldTest.beforeClass
     */
    public static String PROJECT_FILE;
    /**
     * Configuration to insert
     * @see HelloWorldTest.beforeClass
     */
    public static GMnetEngineConfiguration[] CONFIGURATION_TO_INSERT;

    public static int ConnectTimeoutTime = 1;

    public static void setProjectAndConfiguration(String projectFile, GMnetEngineConfiguration[] configurationToInsert) {
        PROJECT_FILE        = projectFile;
        CONFIGURATION_TO_INSERT = configurationToInsert;
        IS_PROJECT_SET_UP   = true;
    }

    public static void setup() {
        DIR                 = System.getProperty("environment");
        GMNET_DIR           = DIR+"/gmnet-git/GMnetENGINE.gmx/";
        GMNET_PROJECT_FILE  = GMNET_DIR+"/GMnetENGINE.project.gmx";
        COMPILED_GAME_DIR   = DIR+"/compiled-game";
        GAME_MAKER_PATH     = System.getProperty("gamemaker-path");
        GAME_MAKER_EXE      = "5piceIDE.exe";
        IS_SET_UP           = true;
    }

    /**
     * Builds an URL to a file in the resource folder.
     * @param resource The resource to find
     * @return The URL that was built
     */
    public static String r(String resource) {
        return Workspace.class.getClassLoader().getResource(resource).getFile();
    }
}
