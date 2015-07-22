///udphp_clientPunch(client_id)

/*
**  Description:
**      This script will try to connect the client, if it's not already connected
**      Requirement: Configured client (udphp_config and udphp_createClient)
**      This should be used in the step event of the client object.
**      If the client doesn't exist or if the connection timed out, this will return false
**  
**  Usage:
**      udphp_clientPunch(client_id)
**
**  Arguments:
**      client_id     real    id of the client to check
**
**  Returns:
**      false if connection times out or the client doesn't exist! Otherwise true
**
*/

var client_id = argument0;

/// CHECK IF CLIENT IS RUNNING (we can use any client-releated variable for that; we assume they don't get changed from outside)
if (!ds_map_exists(global.udphp_clients_udp,client_id)) {
    //Debug level is DEBUG because other than with serverPunch, calling this function is your way of finding out if the server still exists
    udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client_id, "Client not found");
    return false;
    exit;
}

//Set up some local variables, without them this would be a mess...
var client_udp = ds_map_find_value(global.udphp_clients_udp,client_id);
var client_tcp = ds_map_find_value(global.udphp_clients_tcp,client_id);
var client_buffer = ds_map_find_value(global.udphp_clients_buffer,client_id);
var client_timeout = ds_map_find_value(global.udphp_clients_timeout,client_id);
var global_timeout = global.udphp_connection_timeouts;
var client_directconnect = ds_map_find_value(global.udphp_clients_directconnect,client_id);
var client_connected = ds_map_find_value(global.udphp_clients_connected,client_id);
var client_serverip = ds_map_find_value(global.udphp_clients_serverip,client_id);
var client_serverport = ds_map_find_value(global.udphp_clients_serverport,client_id);

//Failsafe, in case a map got corrupted
if (is_undefined(client_udp) or 
    is_undefined(client_tcp) or 
    is_undefined(client_buffer) or 
    is_undefined(client_timeout) or 
    is_undefined(client_connected) or 
    is_undefined(client_serverip) or 
    is_undefined(client_serverport) or 
    is_real(client_serverip) or 
    is_string(client_serverport)) {
    udphp_handleerror(udphp_dbglvl.WARNING, udphp_dbgtarget.CLIENT, 0, "Invalid client data for client "+string(client_id)+" - Stopping client.");
    udphp_stopClient(client_id);
    exit;
}

/// Connect if not already connected
if (!client_connected) { 
    if (client_directconnect) {
        //DIRECT CONNECT or GOT SERVER PORT (and can now connect directly)
        udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client_id, "Connecting with server "+string(client_serverip)+":"+string(client_serverport))
        client_timeout++;
        //Send a packet to the server to punch the hole. If this reaches the server, he will
        //add us to the list of players and send an answer.
        buffer_seek(client_buffer, buffer_seek_start, 0);
        buffer_write(client_buffer, buffer_s8, udphp_packet.KNOCKKNOCK );
        network_send_udp( client_udp, client_serverip, client_serverport, client_buffer, buffer_tell(client_buffer) );
        if (client_timeout > global_timeout) {
            //When the timeout was exceeded, give up and return false to indicate the connection has failed
            udphp_handleerror(udphp_dbglvl.ERROR, udphp_dbgtarget.CLIENT, client_id, "Could not connect to server!")
            //Client get's toppped. Return false, instance must be destroyed now
            udphp_stopClient(client_id);
            return false;
            exit;
        }
        ds_map_replace(global.udphp_clients_timeout,client_id,client_timeout);
    } else {
        //UDP HOLE PUNCH
        //Do nothing, just wait in network event for connection data; There set directconnect to true and set port. Then we will land back here
    }
}
return true;
