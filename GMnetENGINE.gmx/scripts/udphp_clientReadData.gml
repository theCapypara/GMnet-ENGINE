///udphp_clientReadData(clientid)

/*
**  Description:
**      This command does not work well with more than one client (at least
**      not at the same time)
**      The client needs to be connected to a server!
**      
**      Checks the data of the connected server and stores them to:
**      * global.udphp_tmp_data1
**      * global.udphp_tmp_data2
**      * global.udphp_tmp_data3
**      * global.udphp_tmp_data4
**      * global.udphp_tmp_data5
**      * global.udphp_tmp_data6
**      * global.udphp_tmp_data7
**      * global.udphp_tmp_data8
**      
**      You have to monitor those variables yourself. 
**      They are only meant to be used temporarily. Copy their value
**      once it has updated.
**      We recommend setting them to "" if you have copied them. They are
**      "" initialy.
**
**      The data of the server running on this udphp instance can be found in
**      global.updphp_server_data1...      
**
**  Usage:
**      udphp_clientReadData(clientid)
**
**  Arguments:
**      clientid                      int
**
**  Returns:
**      <nothing>
**
*/

var client_id = argument0;

if (!udphp_clientIsConnected(client_id)) {
   udphp_handleerror(udphp_dbglvl.WARNING, udphp_dbgtarget.CLIENT, client_id, "ClientReadData failed: Client was not connected!");
   exit;
}

var client_buffer = ds_map_find_value(global.udphp_clients_buffer,client_id);
var client_udp = ds_map_find_value(global.udphp_clients_udp,client_id);

buffer_seek(client_buffer, buffer_seek_start, 0);

buffer_write(client_buffer, buffer_s8, udphp_packet.DATAREQ);
udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client_id, "ClientReadData. Asking for Server data");
network_send_udp(client_udp,udphp_clientGetServerIP(client_id),udphp_clientGetServerPort(client_id), client_buffer, buffer_tell(client_buffer) );
