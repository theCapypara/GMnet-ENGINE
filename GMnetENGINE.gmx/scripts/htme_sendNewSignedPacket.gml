///htme_sendNewSignedPacket(buffer,target,[exclude],[room]);

/*
**  Description:
**      This will prepare and send a special kind of packet of that is verified that it 
**      arrives.
**      Signed packets are used to create a TCP-like reliability within UDP.
**      
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      buffer    real      ID of the buffer to send
**      target    mixed     STRING [SERVER ONLY]:
**                          the connection details of the client as "ip:port" like they are
**                          stored as keys in the playermap of the server.
**                          OR [REAL/CONSTANTS]:
**                          all [SERVER ONLY] -> Send to all connected players
**                          noone [CLIENT ONLY] -> Send to server
**      [exclude] string    (optional)    
**                          When using all as target this can be used to exclude a single
**                          player; all and noone are not allowed!
**                          Can be empty string for none.
**      [room]    real      If specified:
**                          Creates signed packets for all players in {room} 
**                          except {exclude}
**                          (only works for server)
**  Returns:
**      <nothing>
**
*/

var pre_send_buff = argument[0];
var target = argument[1];
var exclude = "";
if (argument_count > 2) {
    exclude = argument[2];
}
var rroom = -1;
if (argument_count > 3) {
    rroom = argument[3];
}

//We are copying the send_buffer in case it's self.buffer, because that get's overwritten!
var send_buff = buffer_create(buffer_tell(pre_send_buff), buffer_fixed, 1);
buffer_copy(pre_send_buff,0,buffer_tell(pre_send_buff),send_buff,0);
buffer_seek(send_buff, buffer_seek_end, 0);

htme_debugger("htme_sendNewSignedPacket",htme_debug.DEBUG,"Sending signed packet...");

with (global.htme_object) {
    if (is_string(target) || !self.isServer) {
        //Single target
        if (!self.isServer) {
           target = self.server_ip+":"+string(self.server_port);
        }
        htme_initSignedPacket(send_buff,target);
    } else if (target == all) {
        htme_debugger("htme_sendNewSignedPacket",htme_debug.DEBUG,"Target was all: Creating multiple packets.");
        var key= ds_map_find_first(self.playermap);
        //This will loop through all players in the player map
        for(var i=0; i<ds_map_size(self.playermap); i+=1) {
            //Skip local player
            if (key == "0:0") {key = ds_map_find_next(self.playermap, key);continue; }  
            //Skip if exclude
            if (key == exclude) {key = ds_map_find_next(self.playermap, key);continue;}
            if (rroom != -1) {
                //Skip if not in same room
                if (!htme_serverPlayerIsInRoom(key,rroom)) {key = ds_map_find_next(self.playermap, key);continue; } 
            }
            buffer_seek(send_buff, buffer_seek_end, 0);
            htme_initSignedPacket(send_buff,key);
            key = ds_map_find_next(self.playermap, key);
        }
    }
}

buffer_delete(send_buff);
