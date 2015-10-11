///udphp_downloadNetworking()

/*
**  Description:
**      Waits for the lobby response of the master server. Use 
**      udphp_downloadServerList to send a request.
**  
**  Usage:
**      udphp_downloadNetworking()
**
**  Arguments:
**      <none>
**
**  Returns:
**      <nothing>
**
*/

//Set up some local variables.
var in_ip = ds_map_find_value(async_load, "ip");
var in_buff = ds_map_find_value(async_load, "buffer");
var in_id = ds_map_find_value(async_load, "id");
var in_port = ds_map_find_value(async_load, "port");
//global.udphp_downloadServerlistSocket

//Only continue if this is for the "lobby socket"
if (in_id != global.udphp_downloadServerlistSocket) exit;


if (in_ip == global.udphp_master) {
    udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.MAIN, 0, "Downloader: Got message from master server");
    //Read command
    var com = buffer_read(in_buff, buffer_s8 );
    switch com {
        case udphp_packet.MASTER_LOBBY:
            var json = buffer_read(in_buff, buffer_string );
            //Close socket to server
            network_destroy(global.udphp_downloadServerlistSocket);
            global.udphp_downloadServerlistSocket = -1;
            global.udphp_downloadlist_refreshing = false;
            udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.MAIN, 0, json);
            global.udphp_downloadlist_topmap = json_decode(json);
            global.udphp_downloadlist =  global.udphp_downloadlist_topmap[? "default"];
            udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.MAIN, 0, "Downloader: Got lobby data.");
        break;
        default:
            udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.MAIN, 0, "Downloader: Unknown message from master server. ("+string(com)+")");
        break;
    }
} 
