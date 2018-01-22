/// udphp_punchstate(client);

/*  INTERNAL COMMAND
**  Description:
**      Handles states of the punch. This will try different things
**      if the NAT is unfriendly for default udp hole punch.
**  
**  Usage:
**      udphp_punchstate(client)
**
**  Returns:
**      <nothing>
**
*/

var client = argument0;

/// CHECK IF CLIENT IS RUNNING (we can use any client-releated variable for that; we assume they don't get changed from outside)
if (!instance_exists(client)) {
    udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client, "Client not found");
    exit;
}

switch (client.punch_stage)
{
    case udphp_punch_states.TRY_SEQUENCE_PORT:
        switch (client.punch_stage_sub1)
        {
            default:
                // Count up port to use
                client.punch_stage_counter+=1;
                // Reset timeout
                // The time we use to test the new port
                // to test more ports increase the connect timeout variable in config
                client.punch_stage_timeout=global.udphp_punch_stage_timeout_initial;
                // Change port on client
                udphp_handleerror(udphp_dbglvl.WARNING, udphp_dbgtarget.CLIENT, client, "No response. Try connect using sequence server port: " + string(client.punch_stage_external_server_port+client.punch_stage_counter));
                client.server_port = client.punch_stage_external_server_port+client.punch_stage_counter;                
                // Send message and try to connect to server
                network_send_udp( client.udp_socket, client.server_ip, client.punch_stage_external_server_port+client.punch_stage_counter, client.buffer, buffer_tell(client.buffer) );                
                // Try this port for some time
                client.punch_stage_sub1=udphp_punch_substates.SEQ_TRY_NEW;
                break;
            case udphp_punch_substates.SEQ_TRY_NEW:
                // Try new external port
                // Send message and try to connect to server
                network_send_udp( client.udp_socket, client.server_ip, client.punch_stage_external_server_port+client.punch_stage_counter, client.buffer, buffer_tell(client.buffer) );            
                // Wait some to test the other port
                client.punch_stage_timeout-=udphp_get_count();
                // Timeout on this port try another one
                if (client.punch_stage_timeout<=0) {
                    client.punch_stage_sub1=udphp_punch_substates.DEFAULT;
                }
        }
        break;
    case udphp_punch_states.TRY_PREDICTING_PORT:
        switch (client.punch_stage_sub1)
        {
            default:
                if client.punch_stage_predict_value1>client.punch_stage_predict_value2
                {
                    var maxport=client.punch_stage_predict_value1;
                    var minport=client.punch_stage_predict_value2;
                }
                else
                {
                    var maxport=client.punch_stage_predict_value2;
                    var minport=client.punch_stage_predict_value1;                
                }
                // make sure no 0
                if minport=0 minport=1024;
                if maxport=0 maxport=65535;
                // make sure not the same min and max
                // If the server have not restarted the value will be the same then just take some random start point every time
                // to make every try a posibillity to connect
                if minport=maxport minport-=irandom(10000);
                // make sure in limits
                if minport<1024 minport=1024;
                if maxport>65535 maxport=65535;
                // Save values
                client.punch_stage_predict_maxport=maxport;
                client.punch_stage_predict_minport=minport;
                // Put values in a list
                var mytemplist=ds_list_create();
                for (var i=0; i<maxport-minport; i+=1)
                {
                    mytemplist[| i]=minport+i;
                }
                // Random the list
                // This will trick some NATs
                // Else the NAT may detect a port scan or another type of attack and stop it, And we dont want that :-)
                ds_list_shuffle(mytemplist);
                // Reset global test port list
                client.punch_stage_predict_list=-1;
                for (var i=0; i<ds_list_size(mytemplist); i+=1)
                {
                    client.punch_stage_predict_list[i]=real(mytemplist[| i]);
                }
                // remove list and use the array instead to prevent memory leaks
                ds_list_destroy(mytemplist);
                // Set ports to try every step
                // if more than 160 ports the messages will not be sent. This was tested. (Maybe a limit in GM or OS or the NAT)
                client.punch_stage_burst=160;
            case udphp_punch_substates.PRED_CONTINUE:
                // Reset timeout
                // The time we use to test the new port
                // to test more ports increase the connect timeout variable in config
                client.punch_stage_timeout=global.udphp_punch_stage_timeout_initial;
                var startvalue=client.punch_stage_counter;
                var minport=client.punch_stage_predict_minport;
                client.punch_stage_saved_value=minport;
                // Start burst
                for (var i=0; i<client.punch_stage_burst; i+=1)
                {
                    // Count up port to use
                    client.punch_stage_counter+=1;
                    // Check if over max then end this
                    if client.punch_stage_counter>=array_length_1d(client.punch_stage_predict_list) break;                    
                    // Send to new port
                    // Send message and try to connect to server
                    network_send_udp( client.udp_socket, client.server_ip, client.punch_stage_predict_list[client.punch_stage_counter], client.buffer, buffer_tell(client.buffer) );                     
                }
                udphp_handleerror(udphp_dbglvl.WARNING, udphp_dbgtarget.CLIENT, client, "No response. Try connect using predict server port: " + string(client.punch_stage_counter/array_length_1d(client.punch_stage_predict_list)) + "% tested");
                client.punch_stage_sub1=udphp_punch_substates.PRED_REST;
                break;
            case udphp_punch_substates.PRED_REST:
                // Wait some to test the new port
                client.punch_stage_timeout-=udphp_get_count();
                // Timeout on this port try another one
                if client.punch_stage_timeout<=0 
                {
                    // Count up port to use
                    client.punch_stage_counter+=1;                      
                    client.punch_stage_sub1=udphp_punch_substates.PRED_CONTINUE;
                }
        }    
        break;
    case udphp_punch_states.TRY_PROVIDED_PORT:
        // Send message and try to connect to server (with provided port)
        if global.ConnectToServerPort>0
        {
            client.server_port=global.ConnectToServerPort;
        }        
        //show_debug_message("Try: " + string(client.server_port));
        network_send_udp( client.udp_socket, client.server_ip, client.server_port, client.buffer, buffer_tell(client.buffer) );        
        break;
    default:
        // Deafult punch
        // Send message and try to connect to server
        network_send_udp( client.udp_socket, client.server_ip, client.server_port, client.buffer, buffer_tell(client.buffer) );
}
 
