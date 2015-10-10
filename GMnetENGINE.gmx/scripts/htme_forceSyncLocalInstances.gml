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
    
    /**RETRIEVE INFORMATION**/
    var inst_hash = group[? "instancehash"];
    var inst = group[? "instance"];
    if (instance_exists(inst)) {
        var inst_player = (inst).htme_mp_player;   
    } else if (self.isServer) {
        var backupEntry = ds_map_find_value(self.serverBackup,inst_hash);
        if (ds_exists(backupEntry,ds_type_map)) {
            var inst_player = backupEntry[? "player"];      
        } else {
            if (is_undefined(inst_hash) || is_undefined(group[? name])) {
                htme_debugger("htme_forceSyncLocalInstances",htme_debug.WARNING,"CORRUPTED VARGROUP! CONTENTS: "+json_encode(group));
            } else {
                htme_debugger("htme_forceSyncLocalInstances",htme_debug.WARNING,"Could not check var-group "+group[? "name"]+" of instance "+inst_hash+". MISSING BACKUP ENTRY!");
            }
        }
    } else {
        if (is_undefined(inst_hash) || is_undefined(group[? name])) {
            htme_debugger("htme_forceSyncLocalInstances",htme_debug.WARNING,"CORRUPTED VARGROUP! CONTENTS: "+json_encode(group));
        } else {
            htme_debugger("htme_forceSyncLocalInstances",htme_debug.WARNING,"Could not check var-group "+group[? "name"]+" of instance "+inst_hash+". MISSING INSTANCE!");
        }
        exit;
    }
    
    //Only sync desired instances:
    if (inst_player != phash) {continue;}
    htme_syncSingleVarGroup(group,all);
}
self.syncForce = false;
