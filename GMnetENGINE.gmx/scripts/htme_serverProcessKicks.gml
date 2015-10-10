///htme_serverProcessKicks();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Runs the clock on the server kicklist and kicks all clients that timed out.
**  
**  Usage:
**      <see above>
**
**  Arguments:
**      <none>
**
**  Returns:
**      <nothing>
**
*/

var key= ds_map_find_first(self.kickmap);
for(var i=0; i<ds_map_size(self.kickmap); i+=1) {
    var oldval = ds_map_find_value(kickmap,key);
    if (oldval <= 0) {
        htme_serverKickClient(key);
        ds_map_delete(self.kickmap,key);
        exit;
    }
    else {
        ds_map_replace(self.kickmap, key, oldval-1);
    }
    key = ds_map_find_next(self.kickmap, key);
}
