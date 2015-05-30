![GMnet ENGINE](http://parakoopa.de/GMnet/engine.png)
#GMnet ENGINE Repository
This is the repository of GMnet ENGINE - the multiplayer engine for Game Maker Studio.

GMnet ENGINE contains the following three products (all can be used on their own ):

* ![GMnet CORE](http://parakoopa.de/GMnet/small_core.png)
  **GMnet CORE** (all scripts with the **htme_** prefix) is the main part of the engine. It handles the actual synchronization between players. Has functions to integrate PUNCH and ACCESS.

* ![GMnet PUNCH](http://parakoopa.de/GMnet/small_punch.png)
  **GMnet PUNCH** (all scripts with the **udphp_** prefix) handles NAT traversal/UDP hole punching, so players behind firewalls can communicate. It requires GMnet GATE.PUNCH (see below).

* ![GMnet ACCESS](http://parakoopa.de/GMnet/small_access.png)
**!!NOT YET INCLUDED (or even done)!!**
**GMnet ACCESS** (all scripts with the **gmnacc_** prefix) can handle user authentification and can store and recieve data related to users. It requires GMnet GATE.ACCESS (see below).

* This repo also contains a demo project for GMnet ENGINE and GMnet CORE. The demo projects for ACCESS and PUNCH can be found in the repos below

**More information about GMnet ENGINE and other products can be found on the website:**  
http://gmnet.parakoopa.de

##Get GMnet ENGINE, CORE, PUNCH or ACCESS
To get GMnet ENGINE, which combines everything visit  
http://gmnet.parakoopa.de/engine

For the other projects visit  
http://gmnet.parakoopa.de/core (CORE)  
http://gmnet.parakoopa.de/access (ACCESS)  
http://gmnet.parakoopa.de/punch (PUNCH)


##Other repositories

* [GMnet PUNCH demo project](https://github.com/Parakoopa/GMnet-PUNCH-Demo)
* [GMnet ACCESS demo project](https://github.com/Parakoopa/GMnet-ACCESS-Demo)
* [GMnet GATE.ACCESS](https://github.com/Parakoopa/GMnet-GATE-ACCESS)
* [GMnet GATE.PUNCH](https://github.com/Parakoopa/GMnet-GATE-PUNCH)
* [GMnet GATE](https://github.com/Parakoopa/GMnet-GATE) (Installer and service that combines GATE.ACCESS and GATE.PUNCH)
* [GMnet GATE.TESTER](https://github.com/Parakoopa/GMnet-GATE-TESTER) (Web-based debugging tool for other GMnet GATE producs)
* [Manual pages](https://github.com/Parakoopa/GMnet-manual) (Get and edit the manual pages found on http://gmnet.parakoopa.de)

## Branches & Versioning

* The branch ``master`` contains the most recent versions of GMnet CORE, ACCESS and PUNCH, which are still in development. They are usally working but are not recommended for use in production.
* The branch ``releases-core`` contains releases of GMnet CORE. All commits in this branch are tagged with a tag like ``core-VERSION``. This branch is also used for ENGINE releases that can be found on the Game Maker Martketplace. ENGINE releaes have the same version number as CORE releaes and are a combination of the release commit of CORE, and the scripts (udphp\_ and gmnacc\_) of the last commit in ``releases-access`` and ``releases-punch``.
* The branch ``releases-access`` contains releases of GMnet ACCESS. All commits in this branch are tagged with a tag like ``access-VERSION``. The demo project repository for ACCESS also get's tagged with this tag if changed, otherwise the newest commit from this repository is used as demo project. Marketplace releases use the scripts from this commit and the according demo project.
* The branch ``releases-punch`` contains releases of GMnet PUNCH. All commits in this branch are tagged with a tag like ``punch-VERSION``. For how to include the demo project, see ACCESS.
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