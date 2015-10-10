///htme_serverStart(port,maxclients)

/*
**  Description:
**      This script will configure this engine to be used as a server until it is stopped.
**      The server will be started and the engine is ready to use.
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      port        real    The port this server will listen on
**      maxclients  real    The maximum number of players that will be able to connect
**
**  Returns:
**      true if server was created, false if an error occured
**
*/

//Run this script as the htme.
with (global.htme_object) {

var port = argument0;
var maxclients = argument1;

//Create the server socket
htme_debugger("htme_serverStart",htme_debug.DEBUG,"STARTING SERVER");
self.socketOrServer = network_create_socket_ext(network_socket_udp,port);
self.port = port;

//Check if server was created
if(self.socketOrServer<0) {
    htme_debugger("htme_serverStart",htme_debug.ERROR,"Could not start Server! Return of network_create_server: "+string(self.socketOrServer));
    htme_serverStop();
    return false;
}

//Start GMnet PUNCH if needed
if (self.use_udphp) {
    htme_debugger("htme_serverStart",htme_debug.DEBUG,"LOADING GMnet PUNCH");
    self.udphp_playerlist = ds_list_create();
    if(!script_execute(asset_get_index("udphp_createServer"),self.socketOrServer,self.buffer,self.udphp_playerlist)) {
        //Error while starting udphp
        htme_debugger("htme_serverStart",htme_debug.ERROR,"Could not start GMnet PUNCH server instance! Check udphp log, increase log level if neccesary.");
        htme_serverStop();
        return false;
    }
    script_execute(asset_get_index("udphp_serverSetData"),1,self.gamename);
}

//Create playermap, generate hash for local player and add local player
self.playermap = ds_map_create();
self.kickmap = ds_map_create();
self.playerrooms = ds_map_create();
self.playerhash = htme_hash()+"-1";
//IP:Port for local player is always 0:0
ds_map_add(self.playermap,"0:0",self.playerhash);
ds_map_add(self.playerrooms,"0:0",room);
//More maps required for the engine
self.serverTimeoutSend = ds_map_create();
self.serverTimeoutRecv = ds_map_create();

//Signed packet map
self.signedPackets = ds_list_create();
self.signedPacketsCategories = ds_map_create();

//Backup data for instances
self.serverBackup = ds_map_create();

//Playerlist for htme_iteratePlayers
self.playerlist = ds_list_create();
ds_list_add(self.playerlist,self.playerhash);

self.grouplist = ds_list_create();
self.grouplist_local = ds_list_create();

//Global sync map
self.globalsync = ds_map_create();
self.globalsync_datatypes = ds_map_create();

self.chatQueues = ds_map_create();

//Configure state variables
self.started = true;
self.isServer = true;
self.isConnected = true;
htme_debugger("htme_serverStart",htme_debug.INFO,"SERVER STARTED");
return true;
}
