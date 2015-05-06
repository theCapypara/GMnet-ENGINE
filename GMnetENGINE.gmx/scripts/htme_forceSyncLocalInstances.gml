///htme_forceSyncLocalInstances(playerhash);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      If this is called by a client, it force syncs all variable groups to
**      the server
**      If this is run by the server, this force syncs all variable groups
**      to all clients in the same room
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      playerhash  string    the hash of the player
**
**  Returns:
**      <Nothing>
**
*/


var phash = argument0;
self.syncForce = true;

htme_debugger("htme_forceSyncLocalInstances",htme_debug.DEBUG,"Forcing the sync of "+phash+"'s instances.");

//This will loop through all var groups or only lcoal var groups if client
for(var i=0; i<ds_list_size(self.grouplist); i+=1) {
    var group = ds_list_find_value(grouplist,i);
    var inst_hash = group[? "instancehash"];
    var inst = group[? "instance"];
    if (instance_exists(inst)) {
        var inst_groups = (inst).htme_mp_groups;
        var inst_object = (inst).htme_mp_object;
        var inst_player = (inst).htme_mp_player;   
        var inst_stayAlive =  (inst).htme_mp_stayAlive;
    } else if (self.isServer) {
        var backupEntry = ds_map_find_value(self.serverBackup,inst_hash);
        var inst_groups = backupEntry[? "groups"];
        var inst_object = backupEntry[? "object"];
        var inst_player = backupEntry[? "player"];      
        var inst_stayAlive = backupEntry[? "stayAlive"];
    } else {continue;}
    //Only sync desired instances:
    if (inst_player != phash) {continue;}
    htme_syncSingleVarGroup(group,all,inst,inst_hash,inst_object,inst_stayAlive,inst_player);
}
self.syncForce = false;