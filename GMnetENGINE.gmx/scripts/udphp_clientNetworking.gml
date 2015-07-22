///udphp_clientNetworking(client_id)

/*
**  Description:
**      This script will do two things:
**          * Check if the master server sends back server information (the port)
**          * Check if server connection is done.
**      Requirement: Configured client (udphp_config and udphp_createClient)
**      This should be used in the networking event of the client object.
**  
**  Usage:
**      udphp_clientNetworking(client_id)
**
**  Arguments:
**      client_id     real    id of the client to check
**
**  Returns:
**      <nothing>
**
*/
var client_id = argument0;
/// CHECK IF CLIENT IS RUNNING (we can use any client-releated variable for that; we assume they don't get changed from outside)
if (!ds_map_exists(global.udphp_clients_udp,client_id)) {
    udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client_id, "Client not found");
}

//Networking related variables
var in_id = ds_map_find_value(async_load, "id");
var client_udp = ds_map_find_value(global.udphp_clients_udp,client_id);
var client_tcp = ds_map_find_value(global.udphp_clients_tcp,client_id);
var in_buff = ds_map_find_value(async_load, "buffer");
var in_ip = ds_map_find_value(async_load, "ip");

//Only continue if this is for the client
if (in_id != client_udp and in_id != client_tcp) exit;

//Failsafe, in case a map got corrupted
if (is_undefined(client_udp) or 
    is_undefined(client_tcp)) {
    udphp_handleerror(udphp_dbglvl.WARNING, udphp_dbgtarget.CLIENT, 0, "Invalid client data for client "+string(client_id)+" - Stopping client.");
    udphp_stopClient(client_id);
    exit;
}

///SCENARIO 1: Master Server sent an answer
if (in_ip == global.udphp_master) {
    udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client_id, "Got message from master server");
    //Check command
    var com = buffer_read(in_buff, buffer_s8 );
    switch com {
        case udphp_packet.MASTER:
            //master server sent port and ip! Set IP and port and set directconnect to true
            //client will now connect to server
            udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client_id, "Server found!");
            ds_map_replace(global.udphp_clients_serverip,client_id,buffer_read(in_buff, buffer_string ));
            ds_map_replace(global.udphp_clients_serverport,client_id,real(buffer_read(in_buff, buffer_string )));
            ds_map_replace(global.udphp_clients_directconnect,client_id,true);
        break;
        case udphp_packet.MASTER_NOTFOUND:
            //server not found. Try to connect directly.
            udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client_id, "Remote server not connected to master server, try a direct connect.");
            ds_map_replace(global.udphp_clients_directconnect,client_id,true);
        break;
        default:
            udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client_id, "Unknown message from master server. ("+string(com)+")");
        break;
    }
///SCENARIO 2: Connected to server
} else if (!udphp_clientIsConnected(client_id) /* * Sadly in_ip is empty if the server contacts us * && in_ip == ds_map_find_value(global.udphp_clients_serverip,client_id)*/) {
    udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client_id, "Got message from server");
    switch buffer_read(in_buff, buffer_s8 ) {
        case udphp_packet.SERVWELCOME:
            udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client_id, "CONNECTED TO SERVER!");
            //We can kill the socket to the master server now
            network_destroy(client_tcp);
            ds_map_replace(global.udphp_clients_connected,client_id,true);
        break;
    }
} else {
     //SCENARIO 2,5: Check if data was recieved.
     switch buffer_read(in_buff, buffer_s8 ) {
        case udphp_packet.DATA:
             global.udphp_tmp_data1 = buffer_read(in_buff, buffer_string );
             global.udphp_tmp_data2 = buffer_read(in_buff, buffer_string );
             global.udphp_tmp_data3 = buffer_read(in_buff, buffer_string );
             global.udphp_tmp_data4 = buffer_read(in_buff, buffer_string );
             global.udphp_tmp_data5 = buffer_read(in_buff, buffer_string );
             global.udphp_tmp_data6 = buffer_read(in_buff, buffer_string );
             global.udphp_tmp_data7 = buffer_read(in_buff, buffer_string );
             global.udphp_tmp_data8 = buffer_read(in_buff, buffer_string );
             udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client_id, "Got data from server. Check (data1): "+global.udphp_tmp_data1);
             
     }
     //After that we need to reset the buffer for future use
     buffer_seek(in_buff, buffer_seek_start, 0);
}
///SCENARIO X: Packet has nothing to do with GMnet PUNCH, ignore
