///htme_serverBroadcastRoomChange(hash)

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Tell all players to delete the instances of player {hash} if they are
**      not inside the same room. This gets send to all players not in the same
**      room and simply sends them SERVER_INSTANCEREMOVE packets
**      Also resends all instances to all players in the same room
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      hash    string        hash of the player
**
**  Returns:
**      <nothing>
**
*/
var phash = argument0;
var player_id = htme_ds_map_find_key(self.playermap,phash);
var playerroom = ds_map_find_value(self.playerrooms,player_id);

htme_debugger("htme_serverBroadcastRoomChange",htme_debug.DEBUG,"Someone changed room, telling other players to unsync the instances if needed");

var mapToUse = self.globalInstances;
var key= ds_map_find_first(mapToUse);
//This will loop through all global instances
for(var i=0; i<ds_map_size(mapToUse); i+=1) {
   var inst = ds_map_find_value(mapToUse,key);
   //Use backup here, direct access is not safe!
   var backupEntry = ds_map_find_value(self.serverBackup,key);
   if (is_undefined(backupEntry)) {
      var instplayer = (inst).htme_mp_player;
   } else {
      var instplayer = backupEntry[? "player"];
   }
   //This instance belongs to this player; Loop through other players and check
   //room and it's not stayAlive
   if (!htme_isStayAlive(key) && instplayer == phash) {
        var inner_key= ds_map_find_first(self.playerrooms);
        //This will loop through all players rooms
        for(var j=0; j<ds_map_size(self.playerrooms); j+=1) {
            var otherroom = ds_map_find_value(self.playerrooms,inner_key);
            if (playerroom != otherroom) {
               htme_debugger("htme_serverBroadcastRoomChange",htme_debug.DEBUG,"Tell "+inner_key+" to unsync "+inner_key);
               if (inner_key == "0:0") {
                  //Server: 
                  with inst {instance_destroy();}
               } else {
                 //Client: unsync this instance
                 htme_serverBroadcastUnsync(key,inner_key);
               }
            }
            inner_key = ds_map_find_next(self.playerrooms, inner_key);
        }
   }
    key = ds_map_find_next(mapToUse, key);
}

htme_forceSyncLocalInstances(phash);
