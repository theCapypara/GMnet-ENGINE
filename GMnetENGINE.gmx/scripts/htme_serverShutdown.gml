///htme_serverShutdown()

/*
**  Description:
**      Shuts the server down and tells all player about it.
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

var key= ds_map_find_first(self.playermap);
//This will loop through all players in the player map
for(var i=0; i<ds_map_size(self.playermap); i+=1) {
    var hash = ds_map_find_value(self.playermap,key);
    htme_serverDisconnect(hash);
    key = ds_map_find_next(self.playermap, key);
}
htme_serverStop();
