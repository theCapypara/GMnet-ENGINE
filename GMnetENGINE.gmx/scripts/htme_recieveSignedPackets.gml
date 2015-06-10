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
            
            //Process missing cached packets
            var buffs = sender_inmap[? "buffs"];
            if (is_undefined(buffs)) {
                buffs = ds_priority_create();
                sender_inmap[? "buffs"] = buffs;
            }
                        
            for (var i=0; i<5; i++) {
                if (ds_priority_empty(buffs)) break;
                var pr = ds_priority_find_priority(buffs,ds_priority_find_min(buffs));
                if (pr == expected) {
                    //Just what we wanted - process this first
                    var prio_buff = ds_priority_delete_min(buffs);
                    var ip = htme_playerMapIP(sender);
                    var port = htme_playerMapPort(sender);
                    
                    buffer_seek(prio_buff, buffer_seek_start, 0);
                    buffer_read(prio_buff, buffer_s8 );
                    buffer_read(prio_buff, buffer_u32 );
                    htme_debugger("htme_recieveSignedPackets",htme_debug.DEBUG,"SP: Processing from priority list "+sender+":"+string(expected));
                    ds_map_replace(async_load, "buffer", prio_buff);
                    if (self.isServer) {
                        htme_serverNetworking();
                    } else {
                        htme_clientNetworking();
                    }
                    ds_map_replace(async_load, "buffer", in_buff);
                    buffer_delete(prio_buff);
                    if (ds_exists(sender_inmap,ds_type_map)) {
                       expected = expected+1;
                       sender_inmap[? "n"] = expected;
                    }
                    else exit;
                } else if (pr <= expected) {
                    //This was already processed.
                    i--;
                    ds_priority_delete_min(buffs);
                } else break;
            }
            
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
                 if (ds_exists(sender_inmap,ds_type_map))
                    sender_inmap[? "n"] = sender_inmap[? "n"]+1;
                 else exit;
            } else if (missing < 0) {
                //Already processed
                 htme_debugger("htme_recieveSignedPackets",htme_debug.DEBUG,"SP: Doing nothing. Already processed "+sender+":"+string(n));
            } else /*if (missing > 0)*/ {
                htme_debugger("htme_recieveSignedPackets",htme_debug.DEBUG,"SP: Missing "+string(missing)+" signed packets. First missing is "+sender+":"+string(expected));
                //We are missing packets. Ask.
                //TODO: For now we only ask for the oldest missing packet.
                
                buffer_seek(self.buffer, buffer_seek_start, 0);
                buffer_write(self.buffer, buffer_s8, htme_packet.SIGNEDPACKET_NEW_CMD);
                buffer_write(self.buffer, buffer_s8, htme_packet.SIGNEDPACKET_NEW_CMD_REQ);
                buffer_write(self.buffer, buffer_u32, expected);
                network_send_udp( self.socketOrServer, htme_playerMapIP(sender), htme_playerMapPort(sender), self.buffer, buffer_tell(self.buffer));
                
                //Also add this packet to the query.
                buffer_seek(in_buff, buffer_seek_end, 0);
                var cache_buffer = buffer_create(buffer_tell(in_buff), buffer_fixed, 1);
                buffer_copy(in_buff,0,buffer_tell(in_buff),cache_buffer,0);
                buffer_seek(cache_buffer, buffer_seek_end, 0);
                ds_priority_add(buffs,cache_buffer,n);
            }
        break;
        case htme_packet.SIGNEDPACKET_NEW_CMD:
            var subcmd = buffer_read(in_buff, buffer_s8 );
            switch subcmd {
                case htme_packet.SIGNEDPACKET_NEW_CMD_REQ:
                                                                             
                    //A partner is missing a packet. Let's help.
                    var target = in_ip+":"+string(in_port);
                    var n = buffer_read(in_buff, buffer_u32 );
                    htme_debugger("htme_recieveSignedPackets",htme_debug.DEBUG,"SP: Somebody asked about packet"+target+":"+string(n));
                    
                    var target_outmap = ds_map_find_value(self.sPcountOUT,target);
                    if (is_undefined(target_outmap)) {
                        target_outmap = ds_map_create();
                        target_outmap[? "n"] = -1;
                        ds_map_add_map(self.sPcountOUT,target,target_outmap);
                    }
                    var requested = ds_map_find_value(target_outmap,n);
                    if (is_undefined(requested)) {
                       //We don't have this (anymore?)
                       htme_debugger("htme_recieveSignedPackets",htme_debug.WARNING,"SP: MISSING A REQUESTED PACKET!");
                       buffer_write(self.buffer, buffer_s8, htme_packet.SIGNEDPACKET_NEW_CMD);
                       buffer_write(self.buffer, buffer_s8, htme_packet.SIGNEDPACKET_NEW_CMD_MISS);
                       buffer_write(self.buffer, buffer_u32, n);
                       network_send_udp( self.socketOrServer, htme_playerMapIP(target), htme_playerMapPort(target), self.buffer, buffer_tell(self.buffer));
                    } else {
                       htme_debugger("htme_recieveSignedPackets",htme_debug.DEBUG,"SP: We are resending.");
                       htme_sendSingleSignedPacket(target,requested,n);
                    }
                break;
                case htme_packet.SIGNEDPACKET_NEW_CMD_MISS:
                    var target = in_ip+":"+string(in_port);
                    var n = buffer_read(in_buff, buffer_u32 );
                    htme_debugger("htme_recieveSignedPackets",htme_debug.DEBUG,"SP: We got packet missing report: "+target+":"+string(n));
                    //Get Player Inmap
                    var sender_inmap = ds_map_find_value(self.sPcountIN,sender);
                    if (is_undefined(sender_inmap)) {
                        sender_inmap = ds_map_create();
                        sender_inmap[? "n"] = 0;
                        ds_map_add_map(self.sPcountIN,sender,sender_inmap);
                    }
                    
                    //Get current packet id
                    var expected = sender_inmap[? "n"];
                    
                    if (expected == n) {
                       htme_debugger("htme_recieveSignedPackets",htme_debug.DEBUG,"SP: We wanted that packet. Too bad it's gone.");
                       sender_inmap[? "n"] = sender_inmap[? "n"]+1;
                    }
                break;
            }
    }
}
