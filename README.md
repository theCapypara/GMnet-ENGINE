![GMnet ENGINE](http://parakoopa.de/GMnet/engine.png)
#GMnet ENGINE Repository
This is the repository of GMnet ENGINE - the multiplayer engine for Game Maker Studio.

GMnet ENGINE contains the following two products (all can be used on their own ):

* ![GMnet CORE](http://parakoopa.de/GMnet/small_core.png)
  **GMnet CORE** (all scripts with the **htme_** prefix) is the main part of the engine. It handles the actual synchronization between players. Has functions to integrate PUNCH.

* ![GMnet PUNCH](http://parakoopa.de/GMnet/small_punch.png)
  **GMnet PUNCH** (all scripts with the **udphp_** prefix) handles NAT traversal/UDP hole punching, so players behind firewalls can communicate. It requires GMnet GATE.PUNCH (see below).


* This repo also contains a base template project for GMnet ENGINE. The demo projects for the standalone PUNCH version can be found in the repos below

**How to import GMnet:**

**Import your game to GMnet (Best method):**
* 1# Export your game to an extension.
* 2# Open GMnet base template in Game maker studio 1.4 or EA.
* 3# Import your game to the base template.

**Import GMnet to your game (We need to update the extension you export first):**
* 1# Open in Game maker studio 1.4 or EA.
* 2# Extensions>GMnet (double click)
* 3# Click "Export resources" tab
* 4# Click each resource in the right column (Extension:) and click the "Remove" button until every resource is gone.
* 5# Click "Add all"
* 6# Click"Ok".
* 7# Save the project.
* 8# Right click Extensions>GMnet>Export extension
* 9# Open your project and right click Extensions>Import extension
* 10# Import all

**Tutorials how to get started:**  
https://www.youtube.com/watch?v=B2EG55iGuzo&list=PLfMGRgz7yTw-RtXnPV7a51aoZb3fufzZ9

**More information about GMnet ENGINE and other products can be found on the website:**  
http://gmnet.parakoopa.de

##Get GMnet ENGINE, CORE or PUNCH
To get GMnet ENGINE, which combines everything visit  
http://gmnet.parakoopa.de/engine

For the other projects visit  
http://gmnet.parakoopa.de/core (CORE)    
http://gmnet.parakoopa.de/punch (PUNCH)


##Other repositories

* [GMnet PUNCH demo project](https://github.com/Parakoopa/GMnet-PUNCH-Demo)
* [GMnet GATE.PUNCH](https://github.com/Parakoopa/GMnet-GATE-PUNCH)
* [GMnet GATE.TESTER](https://github.com/Parakoopa/GMnet-GATE-TESTER) (Web-based debugging tool for other GMnet GATE products)
* [Manual pages](https://github.com/Parakoopa/GMnet-manual) (Get and edit the manual pages found on http://gmnet.parakoopa.de)

## Branches & Versioning

* The branch ``master`` contains the most recent versions of GMnet CORE and PUNCH, which are still in development. They are usally working but are not recommended for use in production.
* The branch ``releases-core`` contains releases of GMnet CORE. All commits in this branch are tagged with a tag like ``core-VERSION``. This branch is also used for ENGINE releases that can be found on the Game Maker Martketplace. ENGINE releaes have the same version number as CORE releaes and are a combination of the release commit of CORE, and the scripts (udphp\_ and gmnacc\_) of the last commit in ``releases-punch``.
* The branch ``releases-punch`` contains releases of GMnet PUNCH. All commits in this branch are tagged with a tag like ``punch-VERSION``. If you export only the scripts starting with udphp_ and import them into the PUNCH demo project (see above) you get a working standalone version of PUNCH.
* All other branches are used for testing and development and may not work.

## How to commit
This repository contains a Game Maker Studio 1.x project. We want to keep the repo as clean as possible, because of that the following rules apply for commits & pull requests exist:
* Please change this project with the newest beta version of Game Maker or at least make sure the project doesn't create any junk data when using an older version or an early access version. Also make sure everything is working with the newest beta.
* Don't add any files that are not directly releated to any GMnet components or are a requirement of Game Maker to be able to open the project. That includes folders like the ``Config`` and the ``extensions`` folder.
* DON'T ADD COPYRIGHTED IMAGES OR MEDIA that is owned by YoYoGames, such as logos. If such a file is required in the future, replace it with other images, that we have the rights to use (e.g. Public Domain images).
* Do not commit changes to internal Game Maker files, such as the ``.project.gmx``, unless it contains important changes (such as added or removed files).
* Do not commit unused files. Sometimes when copying scripts in GM for example, it might create unused files. Delete them.

## Logo
The GMnet logos use icons from Entypo (http://entypo.com/) and Open Iconic (https://useiconic.com/open/). They are licensed under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
