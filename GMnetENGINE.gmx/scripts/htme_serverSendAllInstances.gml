///htme_serverSendAllInstances(player);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Sends all instances from globalInstances to player
**      ...but only the instances in the same room 
**             (because htme_syncSingleVarGroup only syncs those)!
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      player       string      ip:port
**
**  Returns:
**      <nothing>
**
*/

var target = argument0;
self.syncForce = true;

 htme_debugger("htme_serverSendAllInstances",htme_debug.DEBUG,"Sending all instances to "+target+" due to room change.");

//This will loop through all var groups.
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
                htme_debugger("htme_serverSendAllInstances",htme_debug.WARNING,"CORRUPTED VARGROUP! CONTENTS: "+json_encode(group));
            } else {
                htme_debugger("htme_serverSendAllInstances",htme_debug.WARNING,"Could not check var-group "+group[? "name"]+" of instance "+inst_hash+". MISSING BACKUP ENTRY!");
            }
        }
    } else {
        if (is_undefined(inst_hash) || is_undefined(group[? name])) {
            htme_debugger("htme_serverSendAllInstances",htme_debug.WARNING,"CORRUPTED VARGROUP! CONTENTS: "+json_encode(group));
        } else {
            htme_debugger("htme_serverSendAllInstances",htme_debug.WARNING,"Could not check var-group "+group[? "name"]+" of instance "+inst_hash+". MISSING INSTANCE!");
        }
        exit;
    }
    
    //Skip if own instance
    var phash = ds_map_find_value(self.playermap,target);
    if (inst_player == phash) {continue;}
    //FIXME: Only send to this player! - Sending a string as target is currently broken
    htme_syncSingleVarGroup(group,all);
}

self.syncForce = false;
