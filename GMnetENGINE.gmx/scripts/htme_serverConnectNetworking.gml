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
    switch buffer_read(in_buff, buffer_s8) {
        case htme_packet.CLIENT_REQUESTCONNECT:
            //This is used for non-PUNCH connections to acknowledge the connection
            //on both ends. The actual connection is created by recieving CLIENT_GREETINGS
            //since 1.3.0. This is sent by the client,
            //no matter how it connected.
            buffer_seek(buffer, buffer_seek_start, 0);
            buffer_write(buffer, buffer_s8, htme_packet.SERVER_CONREQACCEPT);
            network_send_udp(self.socketOrServer,in_ip,in_port,buffer,buffer_tell(buffer));
            //We aren't logging this packet. We only log server GREETINGS
        break;
        case htme_packet.CLIENT_GREETINGS:
            var cversion = buffer_read(in_buff, buffer_u16);
            var cgamename = buffer_read(in_buff, buffer_string);
            //Check if compatible
            if (self.gamename != cgamename || cversion < self.version_mayor || cversion >= self.version_mayor+100) {
                htme_debugger("htme_serverConnectNetworking",htme_debug.INFO,in_ip+":"+string(in_port)+" - Client kicked. Not compatible.");
                //CONNECTION REFUSED
                buffer_seek(self.buffer, buffer_seek_start, 0);
                buffer_write(self.buffer, buffer_s8, htme_packet.SERVER_KICKREQ)
                network_send_udp( self.socketOrServer, in_ip, in_port, self.buffer, buffer_tell(self.buffer) );
                if (self.use_udphp) {
                    //Remove from udphp player list
                    var pos = ds_list_find_index(self.udphp_playerlist,in_ip+":"+string(in_port));
                    if (pos != -1)
                        ds_list_delete(self.udphp_playerlist,pos);
                }
                exit;
            }
            //Else: Register a new player
            htme_serverEventPlayerConnected(in_ip,in_port);
    }
}
