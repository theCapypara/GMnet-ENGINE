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
        client.timeout+=udphp_get_count();
        //Send a packet to the server to punch the hole. If this reaches the server, he will
        //add us to the list of players and send an answer.
        buffer_seek(client.buffer, buffer_seek_start, 0);
        buffer_write(client.buffer, buffer_s8, udphp_packet.KNOCKKNOCK );
        // Handle punch states
        udphp_punchstate(client);

        // Change punch stages depending on the total timeout
if (client.punch_stage < udphp_punch_states.TRY_SEQUENCE_PORT && 
          client.timeout > global_timeout*(udphp_punch_states.TRY_SEQUENCE_PORT/100)) {
            // Try change the external server port
            // If the server NAT changed the port to a sequencent port nearby the received port from master server
            // Some NAT change the external port when external ip change in the send network message.
            // Reset some variables we use
            client.punch_stage_sub1= udphp_punch_substates.DEFAULT;
            client.punch_stage_counter=0;            
            // Only config this once
            client.punch_stage = udphp_punch_states.TRY_SEQUENCE_PORT;
            
        } else if (client.punch_stage < udphp_punch_states.TRY_PREDICTING_PORT && 
          client.timeout > (global_timeout*udphp_punch_states.TRY_PREDICTING_PORT/100)) {
            // Try change the external server port
            // If the server NAT changed the port to a random port
            // We can use the last port from the master server as a max and min to predict the next port
            // Some NAT change the external port when external ip change in the send network message.
            // Reset some variables we use
            client.punch_stage_sub1= udphp_punch_substates.DEFAULT;
            client.punch_stage_counter=0;            
            // Only config this once
            client.punch_stage=udphp_punch_states.TRY_PREDICTING_PORT;         
        } else if (client.punch_stage < udphp_punch_states.TRY_PROVIDED_PORT && 
          client.timeout > (global_timeout*udphp_punch_states.TRY_PROVIDED_PORT/100)) {
            // Try change the external server port
            // If the server NAT changed the port to a random port
            // We can use the last port from the master server as a max and min to predict the next port
            // Some NAT change the external port when external ip change in the send network message.
            // Reset some variables we use
            client.punch_stage_sub1= udphp_punch_substates.DEFAULT;
            client.punch_stage_counter=0;    
            // Only config this once
            client.punch_stage=udphp_punch_states.TRY_PROVIDED_PORT;         
        }                 
        
        else if (client.timeout > global_timeout) {
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
