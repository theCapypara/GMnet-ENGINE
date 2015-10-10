///htme_clientStart(server_ip,server_port);

/*
**  Description:
**      This script will configure this engine to be used as a client until it is stopped.
**      The client will be started and try to connect to the server, either via GMnet PUNCH or directly.
**  
**  Usage:
**      <see above>
**
**  Arguments:
**      server_ip          string         The IP of the server to connect to
**      server_port real   real           The port of the server to connect to. This does
**                                        not need o be correctly if you want to rely 100% on
**                                        GMnet PUNCH, as PUNCH will auto-resolve the port if it
**                                        connects via master server.
**
**  Returns:
**      true on success, false on error.
**
*/
//Run this script as the htme.
with (global.htme_object) {

var server_ip = argument0;
var server_port = argument1;

htme_debugger("htme_clientStart",htme_debug.DEBUG,"STARTING CLIENT");

// Create a UDP socket
self.socketOrServer = network_create_socket(network_socket_udp);

if( self.socketOrServer<0 ){   
    //Stop client, when a socket could not be created
    htme_debugger("htme_clientStart",htme_debug.DEBUG,"Could not start Client! Return of network_create_socket: "+string(self.socketOrServer));
    htme_clientStop();
    return false;
}

//Set up ip and port of server
self.server_ip = server_ip;
self.server_port = server_port;

//Set of connection
if (self.use_udphp) {
   htme_debugger("htme_clientStart",htme_debug.DEBUG,"LOADING UDPHP");
   self.udphp_client_id = script_execute(asset_get_index("udphp_createClient"),self.socketOrServer,server_ip,self.buffer,false,server_port);
   if(self.udphp_client_id) {
        //Error while starting udphp
        htme_debugger("htme_clientStart",htme_debug.ERROR,"Could not start GMnet PUNCH client instance! Check GMnet PUNCH log, increase log level if neccesary.");
        htme_serverStop();
        return false;
    }
}

//Signed packet map
self.signedPackets = ds_list_create();
self.signedPacketsCategories = ds_map_create();

//Playerlist for htme_iteratePlayers
self.playerlist = ds_list_create();

self.grouplist = ds_list_create();
self.grouplist_local = ds_list_create();

//Global sync map
self.globalsync = ds_map_create();
self.globalsync_datatypes = ds_map_create();
self.playerhash = "";

self.chatQueues = ds_map_create();

self.server = false;
self.isConnected = false;
self.started = true;
self.clientTimeoutSend = self.global_timeout/2;
self.clientTimeoutRecv = self.global_timeout;
htme_debugger("htme_clientStart",htme_debug.INFO,"CLIENT STARTED, will now connect with server "+string(server_ip)+":"+string(server_port))
return true;
}
