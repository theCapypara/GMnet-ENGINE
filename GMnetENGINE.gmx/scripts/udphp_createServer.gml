///udphp_createServer(udp_server,buffer,player_list)

/*
**  Description:
**      This script will set up everything required for udp holepunching on the server side and activate
**      the master server connection and the GMnet PUNCH server functions
**      Requirement: Configured GMnet PUNCH (udphp_config)
**  
**  Usage:
**      udphp_createServer(udp_server,buffer,player_list)
**
**  Arguments:
**      udp_server        udp server*    A UDP Server created with network_create_server
**      buffer            buffer         A buffer that will be used to send data
**      player_list       ds_list        A list that players will be saved to. Use this to
**                                       get the connected clients. Entries can be parsed with
**                                       udphp_playerListIP and udphp_playerListPort
**
**  Returns:
**      true if server was created, false if an error occured
**
**  *: data type udp server means the argument needs to be the return value of 
**     network_create_server(network_socket_udp,port,maxclients);
**
*/
var udp_server = argument0;
var buffer = argument1;
var player_list = argument2;

udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.SERVER, 0, "Starting...");

//Assign UDP server and create a TCP spcket that we will need to communicate with the master server
//(the master server responds via this tcp socket)
global.udphp_server_udp = udp_server;
global.udphp_server_tcp = network_create_socket(network_socket_tcp);

//Check if both sockets are ready to go
if( global.udphp_server_udp<0 or global.udphp_server_tcp<0 ){    
    udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.SERVER, 0, "Could not start Server!");
    udphp_stopServer();
    return false;
    exit;
}

//Assign buffer
global.udphp_server_buffer = buffer;

//Assign player list. Fail if list does not exist
if (!ds_exists(player_list,ds_type_list)) {
    udphp_handleerror(udphp_dbglvl.WARNING, udphp_dbgtarget.SERVER, 0, "The player-list provided for server startup is invalid.");
    udphp_handleerror(udphp_dbglvl.ERROR, udphp_dbgtarget.SERVER, 0, "Could not start Server!");
    udphp_stopServer();
    return false;
    exit;
}
global.udphp_server_players = player_list;

//Assign some counting variables
//counter is used for server master server reconnection
//Set to 0 so when udphp_serverPunch is run, we will connect to the master server
global.udphp_server_counter = 0;
//incoming_requests stores all client ips with ports that are not yet connected but are trying to via hole punching´
//+Timeouts for connections with incoming requests
//global.udphp_server_incoming_requests<ip:port,timeout>
global.udphp_server_incoming_requests = ds_map_create();
//Similiar to the ones above, however used to send a welcome-packet
//if we are connected with the client (after the connection is done!)
global.udphp_server_incoming_requests2 = ds_map_create();

//Reset the 8 data buffers used for lobby and server identification
//These can be set with udphp_serverSetData(n,string)
//and when connected can be read with udphp_readData()
global.udphp_server_data1 = "";
global.udphp_server_data2 = "";
global.udphp_server_data3 = "";
global.udphp_server_data4 = "";
global.udphp_server_data5 = "";
global.udphp_server_data6 = "";
global.udphp_server_data7 = "";
global.udphp_server_data8 = "";

udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.SERVER, 0, "Started!");
return true;
