///udphp_clientPunch(client)

/*
**  Description:
**      This script will try to connect the client, if it's not already connected
**      Requirement: Configured client (udphp_config and udphp_createClient)
**      This should be used in the step event of the client object.
**      If the client doesn't exist or if the connection timed out, this will return false
**  
**  Usage:
**      udphp_clientPunch(client)
**
**  Arguments:
**      client     real    id of the client to check
**
**  Returns:
**      false if connection times out or the client doesn't exist! Otherwise true
**
*/

var client = argument0;

/// CHECK IF CLIENT IS RUNNING (we can use any client-releated variable for that; we assume they don't get changed from outside)
if (!instance_exists(client)) {
    //Debug level is DEBUG because other than with serverPunch, calling this function is your way of finding out if the server still exists
    udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client, "Client not found");
    return false;
    exit;
}

var global_timeout = global.udphp_connection_timeouts;

//Failsafe, in case data got corrupted
if (is_real(client.server_ip) or 
    is_string(client.server_port)) {
    udphp_handleerror(udphp_dbglvl.WARNING, udphp_dbgtarget.CLIENT, 0, "Invalid client data for client "+string(client)+" - Stopping client.");
    udphp_stopClient(client);
    exit;
}

/// Connect if not already connected
if (!client.connected) { 
    if (client.directconnect) {
        //DIRECT CONNECT or GOT SERVER PORT (and can now connect directly)
        udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client, "Connecting with server "+string(client.server_ip)+":"+string(client.server_port))
        client.timeout++;
        //Send a packet to the server to punch the hole. If this reaches the server, he will
        //add us to the list of players and send an answer.
        buffer_seek(client.buffer, buffer_seek_start, 0);
        buffer_write(client.buffer, buffer_s8, udphp_packet.KNOCKKNOCK );
        network_send_udp( client.udp_socket, client.server_ip, client.server_port, client.buffer, buffer_tell(client.buffer) );
        if (client.timeout > global_timeout) {
            //When the timeout was exceeded, give up and return false to indicate the connection has failed
            udphp_handleerror(udphp_dbglvl.ERROR, udphp_dbgtarget.CLIENT, client, "Could not connect to server!")
            //Client get's stoppped. Return false, instance must be destroyed now
            udphp_stopClient(client);
            return false;
            exit;
        }
    } else {
        //UDP HOLE PUNCH
        //Do nothing, just wait in network event for connection data; There set directconnect to true and set port. Then we will land back here
    }
}
return true;
