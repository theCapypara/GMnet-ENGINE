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
            htme_debugger("htme_recieveSignedPackets",htme_debug.DEBUG,"SP: Recieved "+sender+":"+string(n));
            //Get Player Inmap
            var sender_inmap = ds_map_find_value(self.sPcountIN,sender);
            if (is_undefined(sender_inmap)) {
                sender_inmap = ds_map_create();
                sender_inmap[? "n"] = 0;
                ds_map_add_map(self.sPcountIN,sender,sender_inmap);
            }
            
            //Get current packet id
            var expected = sender_inmap[? "n"];
            
            //Check buffer priority list
            //TODO
            
            //Process packet
            var missing = n-expected;
            if (missing == 0) {
                 //Just what we wanted - continue to process it
                 htme_debugger("htme_recieveSignedPackets",htme_debug.DEBUG,"SP: Processing recieved "+sender+":"+string(n));
                 if (self.isServer) {
                     htme_serverNetworking();
                 } else {
                     htme_clientNetworking();
                 }
                 sender_inmap[? "n"] = sender_inmap[? "n"]+1;
            } else if (missing < 0) {
                //Already processed
                 htme_debugger("htme_recieveSignedPackets",htme_debug.DEBUG,"SP: Doing nothing. Already processed "+sender+":"+string(n));
            } else /*if (missing > 0)*/ {
                htme_debugger("htme_recieveSignedPackets",htme_debug.DEBUG,"SP: Missing "+string(missing)+" signed packets. First missing is "+sender+":"+string(expected));
                //We are missing packets. Ask server.
                //TODO: For now we only ask for the oldest missing packet.
                //TODO
                //Also add this packet to the query.
                //TODO
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
