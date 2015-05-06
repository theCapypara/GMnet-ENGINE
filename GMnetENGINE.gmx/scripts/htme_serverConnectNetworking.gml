///htme_serverConnectNetworking()

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Listens for incoming "connections", replys and registers players.
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      <none>
**
**  Returns:
**      <nothing>
**
*/

htme_debugger("htme_serverConnectNetworking",htme_debug.DEBUG,"SERVER: Checking connection attempts");

//Set up some local variables.
var in_ip = ds_map_find_value(async_load, "ip");
var in_buff = ds_map_find_value(async_load, "buffer");
var in_id = ds_map_find_value(async_load, "id");
var in_port = ds_map_find_value(async_load, "port");
buffer_seek(in_buff, buffer_seek_start, 0);

//SCENARIO: Client that is not yet on the players list connected.
if (is_undefined(ds_map_find_value(self.playermap,in_ip+":"+string(in_port)))) {
    //Read command
    switch buffer_read(in_buff, buffer_s8 ) {
        case htme_packet.CLIENT_REQUESTCONNECT:
            //Also tell him he's connected.
            buffer_seek(buffer, buffer_seek_start, 0);
            buffer_write(buffer, buffer_s8, htme_packet.SERVER_CONREQACCEPT);
            //We are sending the player hash of the local player with every packet, so we
            //don't need to do that here, especially since when using GMnet PUNCH, this can't be
            //done yet anyway
            network_send_udp(self.socketOrServer,in_ip,in_port,buffer,buffer_tell(buffer));
            htme_debugger("htme_serverConnectNetworking",htme_debug.TRAFFIC,"Got packet htme_packet.CLIENT_REQUESTCONNECT from "+in_ip+":"+string(in_port));
            htme_debugger("htme_serverConnectNetworking",htme_debug.TRAFFIC,"Sent packet htme_packet.SERVER_CONREQACCEPT to "+in_ip+":"+string(in_port));
            htme_debugger("htme_serverConnectNetworking",htme_debug.INFO,"CONNECTED TO CLIENT "+in_ip+":"+string(in_port));
            //Register a new player
            htme_serverEventPlayerConnected(in_ip,in_port);
        break;
    }
}