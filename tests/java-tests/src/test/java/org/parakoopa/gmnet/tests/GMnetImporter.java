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

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import static java.nio.file.StandardCopyOption.REPLACE_EXISTING;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import static org.parakoopa.gmnet.tests.Workspace.GMNET_DIR;
import static org.parakoopa.gmnet.tests.Workspace.GMNET_PROJECT_FILE;
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/**
 * Importer to import script files, script XML nodes from the GMnet ENGINE main project
 * into the requested GameMaker test project.
 * Also provides methods to apply GMnetEngineConfigurations.
 * @author Marco Köpcke <parakoopa at live.de>
 */
public class GMnetImporter {

    protected final String projectFile;
    protected final String projectFolder;

    /**
     * Constructs a new importer.
     * @param projectFile      .project.gmx file of the project to import into
     */
    public GMnetImporter(String projectFile) {
        this.projectFile = projectFile;
        this.projectFolder = new File(projectFile).getParent();
    }
    
    /**
     * Copy's all script files from the GMnet ENGINE project into the 
     * target GameMaker project.
     * @return
     * @throws IOException 
     */
    public boolean importScripts() throws IOException {
        new File(projectFolder+"/scripts").mkdir();
        
        File importDir = new File(GMNET_DIR+"/scripts");        
        File[] files = importDir.listFiles();
        for (File file : files) {
            if (!file.isDirectory()) {
                if (file.getName().startsWith("udphp_") 
                        || file.getName().startsWith("htme_")
                        || file.getName().startsWith("mp_")) {
                    copyScriptToProject(file);
                }
            }
        }
        return true;
    }
    
    /**
     * Copy's the XML nodes that represent GMnet ENGINE scripts from the 
     * GMnet ENGINE project file into the target project file. Removes all old
     * GMnet ENGINE nodes before importing.
     * @return
     * @throws ParserConfigurationException
     * @throws SAXException
     * @throws IOException
     * @throws NullPointerException
     * @throws TransformerException 
     */
    public boolean importXML() throws ParserConfigurationException, SAXException, IOException, NullPointerException, TransformerException {
        Document projectXML = DocumentBuilderFactory
                .newInstance()
                .newDocumentBuilder()
                .parse(new File(projectFile));
	Document gmnetXML = DocumentBuilderFactory.newInstance()
                .newDocumentBuilder()
                .parse(new File(GMNET_PROJECT_FILE));
        
        projectXML.getDocumentElement().normalize();
        gmnetXML.getDocumentElement().normalize();
        
        // Check if Project has scripts
        Element scriptsElement = null;
        NodeList nList = projectXML.getElementsByTagName("scripts");
        for (int i = 0; i < nList.getLength(); i++) {
            Node nNode = nList.item(i);
            if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                Element eElement = (Element) nNode;
                if (eElement.getAttribute("name").equals("scripts")) {
                    scriptsElement = eElement;
                }
            }
        }
        if (scriptsElement != null) {
            projectXML.getDocumentElement().removeChild(scriptsElement);
            for (int i = 0; i < scriptsElement.getChildNodes().getLength(); i++) {
                Node nNode = scriptsElement.getChildNodes().item(i);
                if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                    //Clear GMnet folder nodes
                    Element eElement = (Element) nNode;
                    if (eElement.getAttribute("name").equals("udphp")
                            || eElement.getAttribute("name").equals("htme")) {
                        scriptsElement.removeChild(eElement);
                    }
                }
            }
            projectXML.getDocumentElement().appendChild(scriptsElement);
        } else {
            scriptsElement = projectXML.createElement("scripts");
            Attr aAttribute = projectXML.createAttribute("name");
            aAttribute.setValue("scripts");
            scriptsElement.setAttributeNode(aAttribute);
            projectXML.getDocumentElement().appendChild(scriptsElement);
        }
        
        // Wooo... let's start
        Element htmeNode = null;
        Element udphpNode = null;
        NodeList gmnList = gmnetXML.getElementsByTagName("scripts");
        for (int i = 0; i < gmnList.getLength(); i++) {
            Node nNode = gmnList.item(i);
            if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                Element eElement = (Element) nNode;
                //Clear GMnet folder nodes
                if (eElement.getAttribute("name").equals("udphp")) {
                    udphpNode = eElement;
                } if (eElement.getAttribute("name").equals("htme")) {
                    htmeNode = eElement;
                }
            }
        }
        Node udphpNodeCopy = projectXML.importNode(udphpNode, true);
        Node htmeNodeCopy = projectXML.importNode(htmeNode, true);
        scriptsElement.appendChild(htmeNodeCopy);
        scriptsElement.appendChild(udphpNodeCopy);
        projectXML.getDocumentElement().normalize();
        
        // write the content into xml file
        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        Transformer transformer = transformerFactory.newTransformer();
        DOMSource source = new DOMSource(projectXML);
        StreamResult result = new StreamResult(new File(projectFile));
        transformer.transform(source, result);
        return true;
    }
    
    /**
     * Insert <code>GMnetEngineConfiguration</code> objects in array into 
     * htme_config.gml of the target project
     * @param insertConfiguration
     * @return
     * @throws IOException 
     */
    public boolean insertConfiguration(GMnetEngineConfiguration[] insertConfiguration) throws IOException {
        File htmeConfigScript = new File(projectFolder+"/scripts/htme_config.gml");
        try (PrintWriter htmeConfigScriptWriter = new PrintWriter(new BufferedWriter(new FileWriter(htmeConfigScript, true)))) {
            for (GMnetEngineConfiguration singleConfiguration : insertConfiguration) {
                htmeConfigScriptWriter.println("self."+singleConfiguration.VARIABLE+"="+singleConfiguration.VALUE+";");
            }
        }
        return true;
    }

    /**
     * Copy's a single script
     * @param fileToCopy
     * @throws IOException 
     */
    protected void copyScriptToProject(File fileToCopy) throws IOException {
        Files.copy(fileToCopy.toPath(), new File(projectFolder+"/scripts/"+fileToCopy.getName()).toPath(), REPLACE_EXISTING);
    }
    
}
