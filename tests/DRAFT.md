GMnet Tests:
============

**This is the draft for how future automated tests of GMnet should work.**  
  
The whole setup should use...
* Jenkins as CI-Server, 
* seperate Game Maker projects as test-enviroments,
* GameMaker for building the Test-Projects,
* SikuliX for performing UI tests.

The tests either have to give clear visual feedback for SikuliX and/or provide file-based text output containing testing results.  
This means the projects will perform most of the actual testings, while SikuliX will be evalute the results.

Folder-Structure
----------------
This folder will contain the tests, where each folder will represent one test. These test-folders will contain a GameMaker: Studio project, without the htme\_ or udphp\_ scripts installed (those will be imported on build-time).  
The folder will also contain SikuliX script files (propably javascript based), images for checking against while testing, and other test related files.  

Aside from this, this folder will also contain general files for building the project and establishing a connection to the test system.

Planned Tests
-------------

### General Connection
* Using no PUNCH, connecting to a local client directly
* New client: LAN Lobby Connecting

### Connection using PUNCH (PUNCH test) (non restrictive-NAT; Basic Punching)
* Using PUNCH:
* Starting a server
* Connecting server to master server
* New client: Same network, direct connect
* New client: Other network, direct connect
* New client: Connect via Lobby

### PUNCH and restrictive NATs

FUTURE - A future test should also test restrictive NATs.

### Basic syncing
* Testing mp_sync
* Testing syncronization of mp\_addPosition, mp\_addBuiltinBasic, mp\_addBuiltinPhysics
* Testing all buffer types via mp\_add
* Testing mp\_unsync
* Testing mp\_tolerance

Everything in one room with two clients and one server. All participants have one test-instance. One client local, one over internet.

Tests have to go three stages (performed three times with different testing values)

### Extended syncing
* Testing htme\_isLocal
* Testing htme\_isServer
* Testing htme\_getPlayers
* Testing htme\_findPlayerInstace
* Testing htme\_syncGroupNow?

Again three participants. One client local, one over internet.

### CHAT API
* Testing opening one channel via mp\_syncAsChatHandler
* Testing recieving anf sendig over this channel
* Testing opening a second channel
* Testing recieving anf sendig over this channel

Again three participants. One client local, one over internet.

##Global Sync
* SERVER: Set variable via htme_globalSet
* Check on all if recieved
* CLIENT1: Set variable via htme_globalSet
* Check on all if recieved
* CLIENT2: Set variable via htme_globalSetFast
* Check on client1 and client2 if recieved (If failed, jump back to previous, test again 2 times - issue warning)
* All set a different variable
* Check on all if recieved

Again three participants. One client local, one over internet.

### Signed Packets Extras

FUTURE - This test should check if the internals of signed packets are working correctly.

### Room Synchronization + Joining and Disconnecting (5 Players)

With three rooms.  
There is one server-only stayAlive instance.  
There is one normal, one persistent, one stayAlive instance per player.  
All instances change room when player changes room according to their default behaviour.  
TEST expected state of all instances after each step.  
Test using instance aviability and a counter counting up?  

* Server starts (Room1)
* Player2 joins (Room1)
* Server switches room (Room2)
* Player2 switches room  (Room2)
* Player2 switches room  (Room1)
* Server switches room (Room1)
* Server switches room (Room2)
* Player3 joins (Room1)
* Player2 switches room  (Room2)
* Player4 joins (Room1)
* Player4 switches room  (Room3)
* Server switches room (Room1)
* Player2 switches room  (Room1)
* Player3 switches (Room3)
* Player2 switches room  (Room3)
* Player2 switches room  (Room2)
* Player5 joins (Room1)
* Player5 switches room  (Room2)
* Player5 switches room  (Room3)
* Player2 switches room  (Room1)
* Server switches room (Room2)
* For reference; Place of players: (2,1,3,3,3)
* Player 4 disconnects
* Player3 switches (Room2)
* For reference; Place of players: (2,1,2,X,3)
* Player3 disconnects
* Server switches room (Room1)
* Server switches room (Room3)
* For reference; Place of players: (2,1,X,X,3)
* Server ends
* Check if connection is terminated on clients


Do this three times, with this pattern (each entry is a player, 1 means over internet, 0 is local):  
(0,0,0,0,0)  
(1,0,1,0,0)  
(1,1,1,1,1)  

### Cleanup (Starting/Stopping/Starting/Stopping)
* Server creates session
* Client joins
* Client stops
* Client joins
* Server stops (taking client with it)
* Old client opens server
* Old server joins client
* Server closes

All of this should work with no issue. Tested should be using a basic synced object.

### Additonal Lobby Tasks (Setting and Getting Data)
* Set all free data fields while starting server
* Check in client lobby if all fields exists and are correct

If the lobby was reworked things like searching and general lobby functionality should also be tested.

### Authentification Checks
* Check connecting with too high and too low engine version
* Check connecting with wrong gamename
* Check connection event handlers
