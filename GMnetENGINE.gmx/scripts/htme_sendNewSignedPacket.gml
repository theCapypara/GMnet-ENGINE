///htme_sendNewSignedPacket(buffer,target,[exclude]);

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
**  Returns:
**      <nothing>
**
*/

var send_buff = argument[0];
var target = argument[1];
var exclude = "";
if (argument_count > 2) {
    exclude = argument[2];
}

htme_debugger("htme_sendNewSignedPacket",htme_debug.DEBUG,"Sending signed packet...");

with (global.htme_object) {
    if (is_string(target) || !self.isServer) {
        //Single target
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
            htme_initSignedPacket(send_buff,key);
            key = ds_map_find_next(self.playermap, key);
        }
        ds_list_destroy(cmd_list);
    }
}
