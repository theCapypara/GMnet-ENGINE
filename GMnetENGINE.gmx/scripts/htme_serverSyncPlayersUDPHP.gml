///htme_syncPlayersUDPHP()

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Syncs GMnet PUNCH's player list with the player map of htme.
**      We need to make sure, the playermap contains all players from the 
**      player list of GMnet PUNCH but not more.
**      NOTE: This doesn't check if GMnet PUNCH is enabled!
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

htme_debugger("htme_serverSyncPlayersUDPHP",htme_debug.DEBUG,"SERVER: Syncing player map and GMnet PUNCH player list");

//This loop will loop through all players in udphp's player list
for (var i=0;i<ds_list_size(self.udphp_playerlist);i++) {
    var player = ds_list_find_value(self.udphp_playerlist,i);
    //Check if in playermap, if not add.
    if (is_undefined(ds_map_find_value(self.playermap,player))) {
        htme_debugger("htme_serverSyncPlayersUDPHP",htme_debug.INFO,"SERVER: Registered a connection made by GMnet PUNCH.");
        //GMnet PUNCH and GMnet CORE store the player information both as ip:port string, so we can use our functions to split it
        //register new player
        htme_serverEventPlayerConnected(htme_playerMapIP(player),htme_playerMapPort(player));
    }
}
//And now we need to make sure, the map does not contain disconnected players
var key= ds_map_find_first(self.playermap);
//This will loop through all players in the player map
for(var i=0; i<ds_map_size(self.playermap); i+=1) {
    var player = ds_map_find_value(self.playermap,key);
    //Skip local player
    if (key == "0:0") {key = ds_map_find_next(self.playermap, key);continue;}
    //Check if in player list of udphp, if not delete
    if (ds_list_find_index(self.udphp_playerlist,key) == -1) {
        htme_debugger("htme_serverSyncPlayersUDPHP",htme_debug.INFO,"SERVER: Registered, that a client disconnected via GMnet PUNCH.");
        htme_serverEventPlayerDisconnected(key);
        ds_map_delete(self.playermap, key);
        ds_map_delete(self.playerrooms, key);
    }
    key = ds_map_find_next(self.playermap, key);
}