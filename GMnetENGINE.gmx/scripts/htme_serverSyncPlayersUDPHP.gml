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

//Since 1.3.0 we aren't watching the PUNCH client-list anymore.
//Instead we just wait for CLIENT_GREETINGS in htme_serverConnectNetworking
//All invalid entries (entries that connected via PUNCH but didn't send CLIENT_GREETINGS)
//are simply ignored.
//For non-PUNCH connections CLIENT_REQUESTCONNECT and SERVER_CONREQACCEPT
//are still used before sending {CLIENT/SERVER}_GREETINGS

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
