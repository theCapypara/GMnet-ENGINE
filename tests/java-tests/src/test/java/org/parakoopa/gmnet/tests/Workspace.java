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

/**
 * Constants for path configuration.
 * @author Marco Köpcke <parakoopa at live.de>
 */
public class Workspace {
    /**
     * The directory all files produced by the compiler will be put in.
     */
    static final public String DIR = "C:/Users/GMnet/Documents/COMPILE_AREA";
    /**
     * Path to GMnet ENGINE that is going to be tested.
     */
    static final public String GMNET_DIR = DIR+"/gmnet-git/GMnetENGINE.gmx/";
    /**
     * Path to GMnet ENGINE project file that is going to be tested.
     */
    static final public String GMNET_PROJECT_FILE = GMNET_DIR+"/GMnetENGINE.project.gmx";
    /**
     * Path that the compiled test project will be stored in.
     */
    static final public String COMPILED_GAME_DIR = DIR+"/compiled-game";
    
    /**
     * Path to GameMaker installation.
     */
    protected final static String GAME_MAKER_PATH = "C:/Users/GMnet/AppData/Roaming/GameMaker-Studio/";
    /**
     * Name of GameMaker executeable.
     */
    protected final static String GAME_MAKER_EXE = "5piceIDE.exe";
}
