///htme_createSignedPacket(cmd_list,target,category,[exclude],[timeout]);

/*
**  Description:
**      This will prepare and send a special kind of packet of that is verified that it 
**      arrives, as long as that doesn't take the whole duration of {timeout} (in which case)
**      the connection will timeout anyway).
**      Signed packets are used to create a TCP-like reliability within UDP. These packets
**      are heavy on network ressources, use them with care!
**      
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      cmd_list  ds_list   a ds_list containing the content that will be written in
**                          the buffer. Each buffer data type (e.g. buffer_s8) is
**                          followed by the content. Example:
**                          cmd_lst = ds_list_create();
**                          cmd_lst[| 0] = buffer_s8;
**                          cmd_lst[| 1] = htme_packet.PACKET;
**                          
**                          cmd_lst[| 2] = buffer_string;
**                          cmd_lst[| 3] = "foo";
**      target    mixed     STRING [SERVER ONLY]:
**                          the connection details of the client as "ip:port" like they are
**                          stored as keys in the playermap of the server.
**                          OR [REAL/CONSTANTS]:
**                          all [SERVER ONLY] -> Send to all connected players
**                          noone [CLIENT ONLY] -> Send to server
**      category  string    Only one signed packet of this category per target
**                          will exist at a time. The old ones will be removed
**      [exclude] string    (optional)    
**                          When using all as target this can be used to exclude a single
**                          player; all and noone are not allowed!
**                          Can be empty string for none.
**      [timeout] real      if specified, this will overwrite the default timeout
**
**  Returns:
**      <nothing>
**
*/

var cmd_list = argument[0];
var target = argument[1];
var category = argument[2];
var exclude = "";
if (argument_count > 3) {
    exclude = argument[3];
}

htme_debugger("htme_createSignedPacket",htme_debug.DEBUG,"Creating signed packet...");

with (global.htme_object) {
    if (is_string(target) || target == noone) {
        //Single target
        htme_createSingleSignedPacket(cmd_list,target,category);
    } else if (target == all) {
        //Safety first: is Server?
        if (self.isServer) {
            htme_debugger("htme_createSignedPacket",htme_debug.DEBUG,"Target was all: Creating multiple packets.");
            var key= ds_map_find_first(self.playermap);
            //This will loop through all players in the player map
            for(var i=0; i<ds_map_size(self.playermap); i+=1) {
                //Skip local player
                if (key == "0:0") {key = ds_map_find_next(self.playermap, key);continue; }  
                //Skip if exclude
                if (key == exclude) {key = ds_map_find_next(self.playermap, key);continue;}   
                //Send a SignedPacket to all players
                var ccmd_list = ds_list_create();
                ds_list_copy(ccmd_list,cmd_list);
                if (argument_count > 4)
                   htme_createSingleSignedPacket(ccmd_list,key,category,argument[4]);
                else
                   htme_createSingleSignedPacket(ccmd_list,key,category);
                key = ds_map_find_next(self.playermap, key);
            }
            ds_list_destroy(cmd_list);
        }
    }
}