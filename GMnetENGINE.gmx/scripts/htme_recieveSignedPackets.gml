///htme_recieveSignedPackets();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      This does two things:
**          * Checks for incoming "packet recieved" messages and removes these from the list
**            of outgoing packets
**          * Recieve signed packets, processes them and creates
**            "packet recieved" signed packages. These signed packets will be used at
**            the other end for (see above). They will not be replied to! They will simply
**            time out. The timeout is divided by 5 for these packets.
**            TODO: Make that more efficient?
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
        case htme_packet.SIGNEDPACKET:
            htme_debugger("htme_recieveSignedPackets",htme_debug.DEBUG,"Recieved signed packet!");
            var phash = buffer_read(in_buff, buffer_string );
            //Read subcommand
            var subcmd = buffer_read(in_buff, buffer_s8 );
            switch subcmd {
                case htme_packet.SIGNEDPACKET_ACCEPTED:
                    htme_debugger("htme_recieveSignedPackets",htme_debug.DEBUG,"It was an accept message");
                    //The other side confirmed our packet, we don't need to send it anymore
                    var achash = buffer_read(in_buff, buffer_string );
                    for(var i=0; i<ds_list_size(self.signedPackets); i+=1) {
                        var packet = ds_list_find_value(self.signedPackets,i);
                        if (packet[? "hash"] == achash) {
                           htme_removeSignedPacket(i);
                           break;
                        }
                    }
                break;
                default:
                    htme_debugger("htme_recieveSignedPackets",htme_debug.DEBUG,"It was an actual packet with the command id "+string(subcmd));
                    //Ignore packet if we already recieved it before
                    if (ds_list_find_index(self.signedPacketsInCache,phash) != -1) {
                        htme_debugger("htme_recieveSignedPackets",htme_debug.DEBUG,"But we already proccessed it, aborting...");
                        exit;
                    } 
                    htme_debugger("htme_recieveSignedPackets",htme_debug.DEBUG,"Send accpet packet back, cache and proccess");
                    //Another packet was send, create new signed packet with accept-message
                    var cmd_list = ds_list_create();
                    cmd_list[| 0] = buffer_s8;
                    cmd_list[| 1] = htme_packet.SIGNEDPACKET_ACCEPTED;
                    
                    cmd_list[| 2] = buffer_string;
                    cmd_list[| 3] = phash;
                    if (self.isServer) {
                        htme_createSingleSignedPacket(cmd_list,in_ip+":"+string(in_port),htme_hash(),self.global_timeout/10);
                    } else {
                        htme_createSingleSignedPacket(cmd_list,noone,htme_hash(),self.global_timeout/10); 
                    }
                    //Add to local cache, so we don't process this multiple times
                    ds_list_add(self.signedPacketsInCache,phash);
                    //Let the rest be handled by the individual commands
                    buffer_seek(in_buff, buffer_seek_start, 0);
                    buffer_read(in_buff, buffer_s8 ); //Move pointer again
                    buffer_read(in_buff, buffer_string ); //Move pointer again
                    if (self.isServer) {
                        htme_serverNetworking();
                    } else {
                        htme_clientNetworking();
                    }
                break;
            }
        break;
    }
}

if (ds_list_size(self.signedPacketsInCache) > 1000) {
   //Clear signedPackets in cache up
   //WARNING: because this get's done every 1000 packets, some packets may be recieved twice!!
   htme_debugger("htme_recieveSignedPackets",htme_debug.WARNING,"Needed to clear incoming signed packet cache!");
   ds_list_clear(self.signedPacketsInCache);
   //TODO: Only strip some entries, never delete the whole cache.
}
