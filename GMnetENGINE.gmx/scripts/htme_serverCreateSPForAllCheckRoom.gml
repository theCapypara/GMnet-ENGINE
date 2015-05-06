///htme_serverCreateSPForAllCheckRoom(cmd_list,exclude,troom,category,[timeout]);

/*
**  Description:
**      Fork of htme_createSignedPacket
**      Creates signed packets for all players except {exclude} and players
**      that are not in {room}
**      
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      cmd_list  ds_list         see htme_createSignedPacket
**      exclude   string          Exclude a single player (ip:port)
**      room      room id (real)  Exclude all players that are not in this room
**      category  string    Only one signed packet of this category per target
**                          will exist at a time. The old ones will be removed
**      [timeout] real            if specified, this will overwrite the default timeout
**
**  Returns:
**      <nothing>
**
*/

var cmd_list = argument[0];
var exclude = argument[1];
var troom = argument[2];
var category = argument[3];

htme_debugger("htme_serverCreateSPForAllCheckRoom",htme_debug.DEBUG,"Creating signed packet...");

with (global.htme_object) {
    //Safety first: is Server?
    if (self.isServer) {
        htme_debugger("htme_serverCreateSPForAllCheckRoom",htme_debug.DEBUG,"Target was all: Creating multiple packets.");
        var key= ds_map_find_first(self.playermap);
        //This will loop through all players in the player map
        for(var i=0; i<ds_map_size(self.playermap); i+=1) {
            //Skip local player
            if (key == "0:0") {key = ds_map_find_next(self.playermap, key);continue;   }
            //Skip if exclude
            if (key == exclude) {key = ds_map_find_next(self.playermap, key);continue; }
            //Skip if not in same room
            if (!htme_serverPlayerIsInRoom(key,troom)) {key = ds_map_find_next(self.playermap, key);continue; } 
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