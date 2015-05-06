///udphp_serverPunch()

/*
**  Description:
**      This script will do two things:
**         * Connect with master server if counter is reached
**         * Connect with all clients that want to connect via hole punching
**      Requirement: Configured server (udphp_config and udphp_createServer)
**      This should be used in the step event of the server object.
**      Throws a warning to the debug log when server doesn't exist. Don't call this
**      function after you called stopServer.
**  
**  Usage:
**      udphp_serverPunch()
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

/// CONNECT WITH MASTER SERVER FOR HOLE PUNCH REQUESTS
//Set some local variables up for better readability
var buffer = global.udphp_server_buffer;
var server = global.udphp_server_udp;
var server_tcp = global.udphp_server_tcp;
        
//When the reconnection counter is zero (note: this is the case after server creation and after the timeout specified in udphp_config has passsed)
if (global.udphp_server_counter < 1) { 
    //Check if TCP is still open, if yes don't reconnect
    buffer_seek(buffer, buffer_seek_start, 0);
    //reg via TCP tells the server to save the socket that connects us. The server uses this to send us the port
    //of client's that want to connect. This connection needs to be active, for more information look up the difference between TCP and UDP.
    buffer_write(buffer, buffer_string, "ping"+chr(10));
    if(network_send_raw(server_tcp,buffer, buffer_tell(buffer)) < 0) {
        //UDP -> Send Port
        buffer_seek(buffer, buffer_seek_start, 0);
        //reg is the command that the server uses to register us. Via UDP it registers our port number that will be
        //send to the client
        //NOTE: char(10) is newline. The java server needs this for convinience. 
        //     [technically only via tcp but with our master server it's also excepcted via udp by the master server]
        buffer_write(buffer, buffer_string, "reg"+chr(10));
        network_send_udp(server,global.udphp_master, global.udphp_master_port, buffer, buffer_tell(buffer) );
        udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.SERVER, 0, "Reconnecting to master Server - Sent UDP Packet");
        
        
        //TCP -> Open connection
        buffer_seek(buffer, buffer_seek_start, 0);
        //reg via TCP tells the server to save the socket that connects us. The server uses this to send us the port
        //of client's that want to connect. This connection needs to be active, for more information look up the difference between TCP and UDP.
        buffer_write(buffer, buffer_string, "reg2"+chr(10));
        //Send version
        buffer_write(buffer, buffer_string, global.udphp_version+chr(10));
        //Send the 8 data variables
        buffer_write(buffer, buffer_string, global.udphp_server_data1+chr(10));
        buffer_write(buffer, buffer_string, global.udphp_server_data2+chr(10));
        buffer_write(buffer, buffer_string, global.udphp_server_data3+chr(10));
        buffer_write(buffer, buffer_string, global.udphp_server_data4+chr(10));
        buffer_write(buffer, buffer_string, global.udphp_server_data5+chr(10));
        buffer_write(buffer, buffer_string, global.udphp_server_data6+chr(10));
        buffer_write(buffer, buffer_string, global.udphp_server_data7+chr(10));
        buffer_write(buffer, buffer_string, global.udphp_server_data8+chr(10));
        network_destroy(server_tcp);
        //Save this socket so we know the master server speaks to us when checking incoming packets.
        server_tcp = network_create_socket(network_socket_tcp);
        var err = network_connect_raw(server_tcp,global.udphp_master, global.udphp_master_port);
        
        if (err<0) udphp_handleerror(udphp_dbglvl.WARNING, udphp_dbgtarget.SERVER, 0, "Reconnecting to master Server - TCP Connection failed.");
        else {
            err = network_send_raw(server_tcp,buffer, buffer_tell(buffer) );
            if (err<0) udphp_handleerror(udphp_dbglvl.WARNING, udphp_dbgtarget.SERVER, 0, "Reconnecting to master Server - TCP Connection failed.");
            else {
                udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.SERVER, 0,  "Reconnecting to master Server - Reconnected via TCP");
                udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.SERVER, 0, "Reconnecting to master Server - Sent TCP Packet");
                udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.SERVER, 0, "Reconnected to master Server.");
            }
        }
        
        
        //Great. We are connected. If an error occured, we ignore it. 
        //Clients can't connect to us (via hole punching if we are not connected to the master server. They can still
        //connect directly and we will try to reconnect next time.
    }
    global.udphp_server_counter = global.udphp_server_reconnect; //reset counter
} else global.udphp_server_counter--;




/// HOLE PUNCHING REQUESTS
//This get's set up in udphp_serverNetworking and get's processed here!

//Set some local variables up for better readability
//Note: The local variables abobe might also be used
var incoming_requests = global.udphp_server_incoming_requests;
var players = global.udphp_server_players;
var key, i;

//This loop will loop through all incoming requests
key= ds_map_find_first(incoming_requests);
for(i=0; i<ds_map_size(incoming_requests); i+=1) {
    var delete = false; //flag that get's set to true when this entry should be removed from incoming_requests
    var timeout = ds_map_find_value(incoming_requests,key); //port that was stored in the map. We now have the clients ip and port!
    var ip = udphp_playerListIP(key);
    var port = udphp_playerListPort(key);
    
    udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.SERVER, 0, "Conencting with client "+ip+":"+string(port));
    
    if (ds_list_find_index(players,ip+":"+string(port)) != -1 //If we are connected (player is in the player list [he get's stored there in the networking script]
        or timeout > global.udphp_connection_timeouts) //or if the timeout has been reched
        {
        if (timeout > global.udphp_connection_timeouts) udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.SERVER, 0, "Connection timed out.");
        else udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.SERVER, 0, "Connection established."); 
        //Then: Abort connection attempt, either because it's not needed anymore or because we are connected.
        delete = true;
    } else {
        //Else: Try to punch a hole. The client will ignore this packet, it's content is not relevant at all.
        //This is just used to punch the hole.
        buffer_seek(buffer, buffer_seek_start, 0);
        buffer_write(buffer, buffer_s8, udphp_packet.KNOCKKNOCK);
        network_send_udp(server,ip,port,buffer,buffer_tell(buffer));
        timeout++;
        ds_map_replace(incoming_requests,key,timeout); 
    }
    //loop releated stuff
    var tmpkey = ds_map_find_next(incoming_requests,key);
    if (delete) ds_map_delete(incoming_requests,key);
    key = tmpkey;
}


/// SENDING THE WELCOME MESSAGE TO ALL CLIENTS WE SUCCESSFULLY CONNECTED WITH
//This get's set up in udphp_serverNetworking and get's processed here!

//Set some local variables up for better readability
//Note: The local variables abobe might also be used
var incoming_requests2 = global.udphp_server_incoming_requests2;
var players = global.udphp_server_players;
var key, i;

//This loop will loop through all incoming requests2
key= ds_map_find_first(incoming_requests2);
for(i=0; i<ds_map_size(incoming_requests2); i+=1) {
    var delete = false; //flag that get's set to true when this entry should be removed from incoming_requests2
    var timeout = ds_map_find_value(incoming_requests2,key); //port that was stored in the map. We now have the clients ip and port!
    var ip = udphp_playerListIP(key);
    var port = udphp_playerListPort(key);
    
    udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.SERVER, 0, "Making "+ip+" aware we are connected.");
    
    //We are using 3 seconds as a fixed timeout for now
    if (timeout > 3*room_speed) {
        //Timeout has been reached, stop sending
        delete = true;
    } else {
        //Send welcome package
        buffer_seek(buffer, buffer_seek_start, 0);
        buffer_write(buffer, buffer_s8, udphp_packet.SERVWELCOME);
        network_send_udp(global.udphp_server_udp,ip,port,buffer,buffer_tell(buffer));
        timeout++;
        ds_map_replace(incoming_requests2,key,timeout); 
    }
    //loop releated stuff
    var tmpkey = ds_map_find_next(incoming_requests2,key);
    if (delete) ds_map_delete(incoming_requests2,key);
    key = tmpkey;
}
