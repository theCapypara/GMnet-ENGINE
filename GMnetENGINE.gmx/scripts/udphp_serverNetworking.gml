///udphp_serverNetworking()

/*
**  Description:
**      This script will do two things:
**         * Recieve connection information from master server
**         * Tell the client we are connected.
**      Requirement: Configured server (udphp_config and udphp_createServer)
**      This should be used in the networking event of the server object.
**  
**  Usage:
**      udphp_serverNetworking()
**
**  Arguments:
**      <none>
**
**  Returns:
**      <nothing>
**
*/

/// CHECK IF SERVER IS RUNNING (we can use any server-releated variable for that; we assume they don't get changed from outside)
if (global.udphp_server_counter == -1) {
    udphp_handleerror(udphp_dbglvl.WARNING, udphp_dbgtarget.SERVER, 0, "Server was not started.");
    exit;
}

//Set up some local variables.
var in_ip = ds_map_find_value(async_load, "ip");
var in_buff = ds_map_find_value(async_load, "buffer");
var in_id = ds_map_find_value(async_load, "id");
var in_port = ds_map_find_value(async_load, "port");
var incoming_requests = global.udphp_server_incoming_requests;
var incoming_requests2 = global.udphp_server_incoming_requests2;
var players = global.udphp_server_players;

//Only continue if this is for the server
if (in_id != global.udphp_server_udp and in_id != global.udphp_server_tcp) exit;


//SCENARIO 1: Master server sends client information! Somebody wants to connect
if (in_ip == global.udphp_master and in_id == global.udphp_server_tcp) {
    udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.SERVER, 0, "Got message from master server");
    //Read command
    var com = buffer_read(in_buff, buffer_s8 );
    switch com {
        case udphp_packet.MASTER:
            //Comamnd indicates, that a client tries to connect: Store his information in incoming_requests and try to connect in udphp_serverPunch
            var client_ip = buffer_read(in_buff, buffer_string );
            var client_port = real(buffer_read(in_buff, buffer_string ));
            ds_map_add(incoming_requests,client_ip+":"+string(client_port),0);
            udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.SERVER, 0, "Client "+client_ip+string(client_port)+ "wants to connect.");
        break;
        default:
            udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.SERVER, 0, "Unknown message from master server. ("+string(com)+")");
        break;
    }
} 
//SCENARIO 2: Client that is not yet on the players list connected.
else if (ds_list_find_index(players,in_ip+":"+string(in_port)) == -1) {
    //Read command
        switch buffer_read(in_buff, buffer_s8 ) {
        case udphp_packet.KNOCKKNOCK:
            var buffer = global.udphp_server_buffer;
            //Client finally reached us. Store his information in our player list
            ds_list_add(players,in_ip+":"+string(in_port));
            //Also tell him he's connected.
            //UPDATE: We now do this by adding him to a new list and spamming him
            //for the duration of the timeout with the Welcome packet. If he doesn't get it
            //the server thinks we are connected, but we aren't! Time the players out like in
            //the demo to check if they are connected.
            ds_map_add(incoming_requests2,in_ip+":"+string(in_port),0);
            udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.SERVER, 0, "CONNECTED TO CLIENT "+in_ip+":"+string(in_port));
        break;
    }
}
else {
     //SCENARIO 2,5: Check if data was requested.
     switch buffer_read(in_buff, buffer_s8 ) {
        case udphp_packet.DATAREQ:
             udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.SERVER, 0, "Client "+in_ip+":"+string(in_port)+" asked for data");
             //Send data
             buffer_seek(global.udphp_server_buffer, buffer_seek_start, 0);
             buffer_write(global.udphp_server_buffer, buffer_s8, udphp_packet.DATA);
             buffer_write(global.udphp_server_buffer, buffer_string, global.udphp_server_data1);
             buffer_write(global.udphp_server_buffer, buffer_string, global.udphp_server_data2);
             buffer_write(global.udphp_server_buffer, buffer_string, global.udphp_server_data3);
             buffer_write(global.udphp_server_buffer, buffer_string, global.udphp_server_data4);
             buffer_write(global.udphp_server_buffer, buffer_string, global.udphp_server_data5);
             buffer_write(global.udphp_server_buffer, buffer_string, global.udphp_server_data6);
             buffer_write(global.udphp_server_buffer, buffer_string, global.udphp_server_data7);
             buffer_write(global.udphp_server_buffer, buffer_string, global.udphp_server_data8);
             network_send_udp(global.udphp_server_udp,in_ip, in_port, global.udphp_server_buffer, buffer_tell(global.udphp_server_buffer) )
        break;
     }
     //After that we need to reset the buffer for future use
     buffer_seek(in_buff, buffer_seek_start, 0);
     
}
//SCENARIO X: Something not related to udphp, ignore.
