///udphp_clientReadData(client)

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
**      client                      int
**
**  Returns:
**      <nothing>
**
*/

var client = argument0;

if (!udphp_clientIsConnected(client)) {
   udphp_handleerror(udphp_dbglvl.WARNING, udphp_dbgtarget.CLIENT, client, "ClientReadData failed: Client was not connected!");
   exit;
}

buffer_seek(client.buffer, buffer_seek_start, 0);

buffer_write(client.buffer, buffer_s8, udphp_packet.DATAREQ);
udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client, "ClientReadData. Asking for Server data");
network_send_udp(client.udp_socket,udphp_clientGetServerIP(client),udphp_clientGetServerPort(client), client.buffer, buffer_tell(client.buffer) );