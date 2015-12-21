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

import java.io.File;
import java.io.IOException;
import java.net.URL;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import net.lingala.zip4j.core.ZipFile;
import net.lingala.zip4j.exception.ZipException;
import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import static org.parakoopa.gmnet.tests.Workspace.GAME_MAKER_EXE;
import static org.parakoopa.gmnet.tests.Workspace.GAME_MAKER_PATH;
import static org.parakoopa.gmnet.tests.Workspace.r;

import org.sikuli.script.FindFailed;
import org.sikuli.script.Screen;
import org.sikuli.script.App;
import org.sikuli.script.Key;
import org.xml.sax.SAXException;
    
/**
 * 
 * @author Marco Köpcke <parakoopa at live.de>
 */
public class GameMakerCompiler {
        
    protected static int appOpenCounter;
    protected App gameMakerApp;
    protected String projectFile;
    protected GMnetEngineConfiguration[] insertConfiguration;
    protected Logger logger = Logger.getLogger("GLOBAL");

    /**
     * Create a new GameMakerCompiler instance.
     * @param projectFile           Path to the project.gmx file to compile
     * @param insertConfiguration   Configuration to insert into htme_config
     */
    public GameMakerCompiler(String projectFile, GMnetEngineConfiguration[] insertConfiguration) {
        GameMakerCompiler.appOpenCounter = 0;
        this.projectFile = projectFile;
        this.insertConfiguration = insertConfiguration;
    }
    
    /**
     * Run the GameMaker: Studio IDE, compile the game and unzip the result.
     * @throws IOException
     * @throws InterruptedException
     * @throws CompilingFailedException
     * @throws ParserConfigurationException
     * @throws SAXException
     * @throws NullPointerException
     * @throws TransformerException 
     */
    public void compile() throws IOException, InterruptedException, CompilingFailedException, ParserConfigurationException, SAXException, NullPointerException, TransformerException {
        Screen s = new Screen();
        
        cleanUp();
        if (!prepareProjectFile(insertConfiguration)) {
            throw new CompilingFailedException("Could not prepare project file");
        }
        if (!openGameMaker()) {
            throw new CompilingFailedException("Could not open GameMaker");
        }
        try {
            s.wait(r("images/all/gamemaker_toolbar.png"), 60);
        } catch (FindFailed ex) {
            //Continue anyway 
            logger.warn("[GameMakerCompiler] Could not find GameMaker window.");
        }
        Thread.sleep(2000);
        logger.info("[GameMakerCompiler] Start compiling sequence...");
        try {
            s.click(r("images/all/gamemaker_c_sprites.png"));
        } catch (FindFailed ex) {
            throw new CompilingFailedException("Could not focus GameMaker window");
        }
        s.type("c", Key.CTRL + Key.ALT);
        Thread.sleep(2000);
        
        s.paste(getWindowsPath(Workspace.DIR)+"\\compiled-game.zip");
        s.type(Key.TAB);
        s.type(Key.DOWN);
        s.type(Key.DOWN);
        s.type(Key.DOWN);
        s.type(Key.ENTER);
        s.type(Key.ENTER);
        Thread.sleep(200);
        s.type(Key.LEFT);
        s.type(Key.ENTER);
        logger.info("[GameMakerCompiler] Wait for compiler to finish...");
        try {
            s.wait(r("images/all/gamemaker_c_createfinished.png"), 60);
        } catch (FindFailed ex) {
            logger.warn("[GameMakerCompiler] Could not confirm successful compilation.");
        }
        
        gameMakerApp.close();
        logger.info("[GameMakerCompiler] Unzip game...");
        try {
            // Unzip compiled game
            ZipFile zippedGame = new ZipFile(Workspace.DIR+"/compiled-game.zip");
            File unzipDir = new File(Workspace.COMPILED_GAME_DIR);
            unzipDir.mkdir();
            zippedGame.extractAll(Workspace.COMPILED_GAME_DIR);
            // Rename executeable to something more standard.
            String expectedExeName = new File(projectFile).getName().replaceFirst(".project.gmx", ".exe");
            File gameExe = new File(Workspace.COMPILED_GAME_DIR+"/"+expectedExeName);
            if (!gameExe.exists()) {
                throw new CompilingFailedException("Can not rename game executeable.");
            }
            gameExe.renameTo(new File(Workspace.COMPILED_GAME_DIR+"/game.exe"));
        } catch (ZipException ex) {
            throw new CompilingFailedException("Zip couldn't be unzipped. Compiling propably failed.");
        }
        //Cleanup
        logger.debug("[GameMakerCompiler] Kill IDE...");
        killIDE();
        logger.info("[GameMakerCompiler] Compiling (hopefully) finished");
    }
    
    /**
     * Kill IDEs and remove compiled directory & zip.
     * @throws IOException 
     */
    protected void cleanUp() throws IOException {
        logger.info("[GameMakerCompiler] Cleaning up...");
        killIDE();
        File compileDir = new File(Workspace.DIR);
        if (!compileDir.exists()) {
            compileDir.mkdir();
        }
        File gameZip = new File(Workspace.DIR+"/compiled-game.zip");
        if (gameZip.exists()) {
            gameZip.delete();
        }
        gameZip.createNewFile();
        File gameFolder = new File(Workspace.COMPILED_GAME_DIR);
        if (gameFolder.exists()) {
            FileUtils.deleteDirectory(gameFolder);
        }
    }

    /**
     * Launch Game Maker.
     * @throws IOException 
     */
    protected boolean openGameMaker() throws IOException {
        logger.info("[GameMakerCompiler] Opening GameMaker..");
        appOpenCounter = 0;
        gameMakerApp = new App(GAME_MAKER_PATH+GAME_MAKER_EXE+" \""+getWindowsPath(projectFile)+"\"");
        gameMakerApp.open(7);
        if (!gameMakerApp.isValid()) {
            if (appOpenCounter < 3) {
                appOpenCounter++;
                killIDE();
                return openGameMaker();
            } else {
                // Opening Game Maker failed.
                return false;
            }
        }
        return true;
    }

    /**
     * Import configuration and GMnet ENGINE files into the project.
     * @param insertConfiguration
     * @throws IOException
     * @throws ParserConfigurationException
     * @throws SAXException
     * @throws NullPointerException
     * @throws TransformerException 
     */
    protected boolean prepareProjectFile(GMnetEngineConfiguration[] insertConfiguration) throws IOException, ParserConfigurationException, SAXException, NullPointerException, TransformerException {
        logger.info("[GameMakerCompiler] Importing GMnet ENGINE into test project...");
        GMnetImporter gmnetImporter = new GMnetImporter(projectFile);
        return gmnetImporter.importScripts()
                && gmnetImporter.importXML()
                && gmnetImporter.insertConfiguration(insertConfiguration);
    }
    
    /**
     * Kills all 5piceIDE.exe processes.
     * @throws IOException 
     */
    public void killIDE() throws IOException {
        killProcess("5piceIDE.exe");
    }
    
    /**
     * Check if game.exe is created, not empty and executeable
     * @return 
     */
    public static boolean gameExeExists() {
        File game = new File(Workspace.COMPILED_GAME_DIR+"/game.exe");

        return game.exists() && game.length() != 0 && game.canExecute();
    }
    
    /**
     * Kill ALL games.
     * @throws IOException 
     */
    public void killGame() throws IOException {
        killProcess("game.exe");
    }

    /**
     * Run a new game instance
     * @return  SikuliX app representation
     */
    public static App runGame() {
        Logger.getLogger("GLOBAL").debug("[GameMakerCompiler] Run game...");
        appOpenCounter = 0;
        if (!gameExeExists()) {
            return null;
        }

        //Add random string so SikuliX does recognize two seperate games
        App gameApp = new App("+" + Workspace.COMPILED_GAME_DIR+"/game.exe");
        gameApp.open(10);
        if (!gameApp.isValid()) {
            if (appOpenCounter < 3) {
                appOpenCounter++;
                //killGame();
                return runGame();
            } else {
                // Running Game failed
                return null;
            }
        }
        return gameApp;
    }


    protected String getWindowsPath(String input) {
        return new File(input).getAbsoluteFile().toString();
    }
    
    protected void killProcess(String serviceName) throws IOException {
        Runtime.getRuntime().exec("taskkill /F /IM " + serviceName);
    }
}
