///htme_init()

/* 
**   _    _            _ 
**  | |  | |          | |
**  | |__| | ___ _   _| |
**  |  __  |/ _ \ | | | |
**  | |  | |  __/ |_| |_|
**  |_|  |_|\___|\__, (_)
**                __/ |  
**               |___/   
**            
**  CONFIGURATION HAS MOVED!
**  The configuration is now located in htme_config.
**  Please don't make chanegs to this file anymore.
**  
**  htme_config normally doesn't need to be updated when 
**  you update GMnet ENGINE.
**  If it does, you will be warned when starting your game.
*/

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      This will load all variables and settings required by GMnet CORE/ENGINE.
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      <None>
**
**  Returns:
**      <Nothing>
**
*/

/*=================
 *** BELOW: INTERNAL VARIABLES - DO NOT CHANGE 
 =================*/
 
/** 
 * ID of the Object that controls the engine. You normally don't have to change this.
 * @type real
 */
global.htme_object = self.id;

/** 
 * This will randomize the random functions. If you need a certain hash change this.
 */
randomize();


htme_config();
htme_debugger("htme_init",htme_debug.INFO,"SETTING UP GMnet CORE");
htme_debugger("htme_init",htme_debug.DEBUG,"Loaded configuration");

var currentConfigVersion = 1;

if (self.config_version != currentConfigVersion) {
   show_message("You need to update your GMnet configuration.#
       Plese have a look at the changelog in the manual or on the marketplace page for more information.");
   htme_debugger("htme_init",htme_debug.DEBUG,"Config Version check NOT successful");
   //Destroy event crashes game if this variable isn't set
   self.isConnected = false;
   instance_destroy();
   exit;
}
htme_debugger("htme_init",htme_debug.DEBUG,"Config Version check successful");

/***
 *** ENUMS - CONFIGURATION CAN BE FOUND BELOW! 
 ***/

enum htme_debug {NONE=-1,DEBUG=0,TRAFFIC=1,CHATDEBUG=2,INFO=3,WARNING=4,ERROR=5};

//first part of buffer: htme packets start at 100, they are signed 8bit
enum htme_packet {
    PING=100,
    CLIENT_REQUESTCONNECT=101,
    SERVER_CONREQACCEPT=102,
    SERVER_GREETINGS=103,
    SERVER_PLAYERCONNECTED=104,
    INSTANCE_VARGROUP=105,
    CLIENT_INSTANCEREMOVED=106,
    SERVER_INSTANCEREMOVED=107,
    CLIENT_ROOMCHANGE=108,
    SERVER_PLAYERDISCONNECTED=109,
    GLOBALSYNC=110,
    SERVER_KICKREQ=111,
    CLIENT_BYE=113,
    SERVER_BROADCAST=114,
    CHAT_API=115,
    CLIENT_GREETINGS=116,
    SERVER_PLEASE_RESYNC=117,
    SIGNEDPACKET_NEW=125,
    SIGNEDPACKET_NEW_CMD=124,
    SIGNEDPACKET=126,
    SIGNEDPACKET_ACCEPTED=127,
    SIGNEDPACKET_NEW_CMD_REQ=1,
    SIGNEDPACKET_NEW_CMD_MISS=2
}

enum mp_type {
    FAST=0, /*Syncs by simply sending a packet to client or servers
            when sent to the server, the server will send it back to
            the clients when the timeout for that group on the server is over*/
    IMPORTANT=1, /*Uses signed packets to ensure that all servers and clients recieve the
                information, like TCP would do. This is quite slow! When messages arrive at
                the server, the packets will be relayed to all clients*/
    SMART=2, /* Same as important, but only sync if a variable has changed.
              If a tolerance is set, it will also only sync if it passed the
              tolerance for reals*/
}

/**
 * Extends the buffer_ constants and is used for the mp_add* functions to threat builtin
 * variable groups synced between instances differently and allows multiple datatypes in one
 * variable group of an instance. The names correspond to the mp_add* functions with the same
 * name
 **/
enum mp_buffer_type {
    BUILTINBASIC=100,BUILTINPHYSICS=101,BUILTINPOSITION=102
}
 
/** VERSION **/
//(1.3.0 = 1300; 1.3.1 = 1301; 1.3.11 = 1311...)
self.version = 1301;
//The last mayor release. Servers support clients that have a version of
//version_mayor <= client_version < version_mayor+100
self.version_mayor = 1300;
 
if (self.use_udphp) {
    htme_debugger("htme_init",htme_debug.INFO,"Starting GMnet PUNCH...");
    var u_debug = false, u_silent = true;
    if (self.debuglevel <= htme_debug.INFO) {u_debug=false;u_silent=false;}
    if (self.debuglevel <= htme_debug.DEBUG) {u_debug=true;u_silent=false;}
    if (self.debuglevel == htme_debug.TRAFFIC) {u_debug=false;u_silent=true;}
    script_execute(asset_get_index("udphp_config"),self.udphp_master_ip, self.udphp_master_port,self.udphp_rctintv,self.global_timeout,u_debug,u_silent);
}

//Is the engine started by creating a server or client?
self.started = false;
//true -> Server, false -> Client
self.isServer = false;
//ONLY CLIENTS: Is the client connected? [when used with server always true]
self.isConnected = false;
//The client id used for udphp.
self.udphp_client_id = 0;
//The UDP server or socket created by the client/server creation scripts
self.socketOrServer = -1;
//Server ip [ONLY FOR CLIENT]
self.server_ip = "";
//Server port [ONLY FOR CLIENT]
self.server_port = 0;
//Buffer used for everything
self.buffer = buffer_create(256, buffer_grow, 1);
//Player list for GMnet PUNCH ONLY [we use a different type of player map;see below] [Only for server with udphp]
self.udphp_playerlist = -1;
//Playermap. Contains entry with the format <ip:port> -> <playerhash> [Only server!]
self.playermap = -1;
//Kickmap - When clients will be forced to be kicked <ip:port> -> <time till kicked in steps> [Only server!]
self.kickmap = -1;
//Local playerhash.
self.playerhash = "";
//Timeout counter for client
self.client_timeout = 0;
//True if a client was running but stooped
self.clientStopped = false;
//Client timeout check
self.clientTimeoutSend = 0;
self.clientTimeoutRecv = 0;
//Server timeout check (ds_map) -> <ip:port> -> real
self.serverTimeoutSend = -1;
self.serverTimeoutRecv = -1;
//List of locally controlled instances <hash> -> <instance_id> 
self.localInstances = ds_map_create();
//List of all controlled instances <hash> -> <instance_id> 
self.globalInstances = ds_map_create();
//
self.tmp_creatingNetworkInstance = false;
self.tmp_creatingNetworkInstanceNoGroups = false;
//Playermap for romms. Contains entry with the format <ip:port> -> <room> [Only server!]
self.playerrooms = -1;
//Server backup map for instance data
self.serverBackup = -1;
//Force the sync of mp_type.SMART packets
self.syncForce = false;
//A list used to store playerhashes used in htme_iteratePlayers
self.playerlist = -1;
//
self.tmp_instanceForceCreated = false;
//Link stores a link to all vargroups for looping over them, since this is more
//efficient than looping over instance maps and then var group maps.
self.grouplist = -1;
//The same for only local instances (server)
self.grouplist_local = -1;
//
self.tmp_creatingNetworkInstanceHash = "";
//the 7 data strings (2-8)
self.server_data2 = "";
self.server_data3 = "";
self.server_data4 = "";
self.server_data5 = "";
self.server_data6 = "";
self.server_data7 = "";
self.server_data8 = "";
//global sync map
self.globalsync = noone;
self.globalsync_datatypes = noone;
//
self.dbgstate = vk_f12;
self.dbgpage = 0;
self.dbgcntx = "";
self.dbgcntx2 = "";
self.port = -1;
self.lanlobby = ds_list_create();
self.lanlobbysearch = false;
self.lanlobbyfilter = "";
self.lanlobbyport = 0;
self.lanlobbysearchserver = -1;
self.lan_intervalpnt = self.lan_interval;
self.serverEventHandlerConnect = htme_defaultEventHandler;
self.serverEventHandlerDisconnect = htme_defaultEventHandler;
self.chatQueues = -1;
//Signed Packet Count Map - Sending
/*STRUCTURE:
    self.sPcountOUT -> 
                      [ip:port] -> ds_map ->
                                            n -> real
                                            [i] -> buffer
*/                                              
       
self.sPcountOUT = ds_map_create();
//Signed Packet Count Map - Recieving
/*STRUCTURE:
    self.sPcountIN -> 
                      [ip:port] -> ds_map ->
                                            n -> real
                                            buffs -> ds_priority -> 
                                                                   [i] -> buffer
*/       
self.sPcountIN = ds_map_create();
