/// udphp_punchstate(client_id,client_udp,client_serverip,client_serverport,client_buffer);

/*  INTERNAL COMMAND
**  Description:
**      Handles states of the punch. This will try different things
**      if the NAT is unfriendly for default udp hole punch.
**  
**  Usage:
**      udphp_punchstate(client_id,client_udp,client_serverip,client_buffer)
**
**  Returns:
**      <nothing>
**
*/

var client_id = argument0;
var client_udp = argument1;
var client_serverip = argument2;
var client_serverport = argument3;
var client_buffer = argument4;

switch (global.udphp_punch_stage)
{
    case "Try sequence external server port":
        switch (global.udphp_punch_stage_sub1)
        {
            case "":
                // Count up port to use
                global.udphp_punch_stage_counter+=1;
                // Reset timeout
                // The time we use to test the new port
                // to test more ports increase the connect timeout variable in config
                global.udphp_punch_stage_timeout=global.htme_object.global_punch_stage_timeout;
                // Change port on client
                udphp_handleerror(udphp_dbglvl.WARNING, udphp_dbgtarget.CLIENT, client_id, "No response. Try connect using sequence server port: " + string(global.udphp_punch_stage_external_server_port+global.udphp_punch_stage_counter));
                ds_map_replace(global.udphp_clients_serverport,client_id,global.udphp_punch_stage_external_server_port+global.udphp_punch_stage_counter);                
                // Send message and try to connect to server
                network_send_udp( client_udp, client_serverip, global.udphp_punch_stage_external_server_port+global.udphp_punch_stage_counter, client_buffer, buffer_tell(client_buffer) );                
                // Try this port for some time
                global.udphp_punch_stage_sub1="Try new external port";
                break;
            default:
                // Send message and try to connect to server
                network_send_udp( client_udp, client_serverip, global.udphp_punch_stage_external_server_port+global.udphp_punch_stage_counter, client_buffer, buffer_tell(client_buffer) );            
                // Wait some to test the other port
                global.udphp_punch_stage_timeout-=1;
                // Timeout on this port try another one
                if global.udphp_punch_stage_timeout<=0 global.udphp_punch_stage_sub1="";
        }
        break;
    case "Try predict external server port":
        switch (global.udphp_punch_stage_sub1)
        {
            case "":
                if global.udphp_punch_stage_predict_value1>global.udphp_punch_stage_predict_value2
                {
                    var maxport=global.udphp_punch_stage_predict_value1;
                    var minport=global.udphp_punch_stage_predict_value2;
                }
                else
                {
                    var maxport=global.udphp_punch_stage_predict_value2;
                    var minport=global.udphp_punch_stage_predict_value1;                
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
                global.udphp_punch_stage_predict_maxport=maxport;
                global.udphp_punch_stage_predict_minport=minport;
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
                global.udphp_punch_stage_predict_list=-1;
                for (var i=0; i<ds_list_size(mytemplist); i+=1)
                {
                    global.udphp_punch_stage_predict_list[i]=real(mytemplist[| i]);
                }
                // remove list and use the array instead to prevent memory leaks
                ds_list_destroy(mytemplist);
                // Set ports to try every step
                // if more than 160 ports the messages will not be sent. This was tested. (Maybe a limit in GM or OS or the NAT)
                global.udphp_punch_stage_burst=160;
            case "continue":
                // Reset timeout
                // The time we use to test the new port
                // to test more ports increase the connect timeout variable in config
                global.udphp_punch_stage_timeout=global.htme_object.global_punch_stage_timeout;            
                var startvalue=global.udphp_punch_stage_counter;
                var minport=global.udphp_punch_stage_predict_minport;
                global.udphp_punch_stage_saved_value=minport;
                // Start burst
                for (var i=0; i<global.udphp_punch_stage_burst; i+=1)
                {
                    // Check if over max then end this
                    if is_undefined(global.udphp_punch_stage_predict_list[global.udphp_punch_stage_counter]) break;
                    // Count up port to use
                    global.udphp_punch_stage_counter+=1;                    
                    // Send to new port
                    // Send message and try to connect to server
                    network_send_udp( client_udp, client_serverip, global.udphp_punch_stage_predict_list[global.udphp_punch_stage_counter], client_buffer, buffer_tell(client_buffer) );                     
                }
                udphp_handleerror(udphp_dbglvl.WARNING, udphp_dbgtarget.CLIENT, client_id, "No response. Try connect using predict server port: " + string(global.udphp_punch_stage_counter/array_length_1d(global.udphp_punch_stage_predict_list)) + "% tested");
                global.udphp_punch_stage_sub1="Rest";
                break;
            default:
                // Wait some to test the new port
                global.udphp_punch_stage_timeout-=1;
                // Timeout on this port try another one
                if global.udphp_punch_stage_timeout<=0 
                {
                    // Count up port to use
                    global.udphp_punch_stage_counter+=1;                      
                    global.udphp_punch_stage_sub1="continue";
                }
        }    
        break;
    default:
        // Deafult punch
        // Send message and try to connect to server
        network_send_udp( client_udp, client_serverip, client_serverport, client_buffer, buffer_tell(client_buffer) );
}
 
