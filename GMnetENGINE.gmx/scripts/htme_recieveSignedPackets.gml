///htme_recieveSignedPackets();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**      Recieves signed packets (Networking event!)
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      <None>
**
**  Returns:
**      <Nothing>
**
*/

//Make sure, we are connected or server
if (!self.isServer && !(!self.isServer && self.isConnected)) exit;

htme_debugger("htme_recieveSignedPackets",htme_debug.DEBUG,"Checking signed packets...");


//Set up some local variables.
var in_ip = ds_map_find_value(async_load, "ip");
var in_buff = ds_map_find_value(async_load, "buffer");
var in_id = ds_map_find_value(async_load, "id");
var in_port = ds_map_find_value(async_load, "port");

buffer_seek(in_buff, buffer_seek_start, 0);
//Create playermap if it doesn't exist, fix for YYC compatibility
if not ds_exists(self.playermap,ds_type_map)
    self.playermap = ds_map_create()

//Check if the sender is valid
if ((self.isServer && !is_undefined(ds_map_find_value(self.playermap,in_ip+":"+string(in_port)))) ||
    (!self.isServer && in_ip == self.server_ip && in_port == self.server_port)) {
    //Read command
    var code = buffer_read(in_buff, buffer_s8 );
    switch code {
        case htme_packet.SIGNEDPACKET_NEW:
            htme_debugger("htme_recieveSignedPackets",htme_debug.DEBUG,"Recieved signed packet!");
            
            var sender = in_ip+":"+string(in_port);
            var n = buffer_read(in_buff, buffer_u32 );
            //!!!!CHECK ID HERE!!!!
            if (true) {
                buffer_seek(in_buff, buffer_seek_start, 0);
                buffer_read(in_buff, buffer_s8 ); //Move pointer again
                buffer_read(in_buff, buffer_u16 ); //Move pointer again
                if (self.isServer) {
                    htme_serverNetworking();
                } else {
                    htme_clientNetworking();
                }
            }
        break;
        case htme_packet.SIGNEDPACKET_NEW_CMD:
            var subcmd = buffer_read(in_buff, buffer_s8 );
            switch subcmd {
                case htme_packet.SIGNEDPACKET_NEW_CMD_REQ:
                break;
                case htme_packet.SIGNEDPACKET_NEW_CMD_MISS:
                break;
            }
    }
}
