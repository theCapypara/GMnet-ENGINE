///mp_sync()

/*
**  Description:
**      Configures this instance to be synced via GMnet CORE.
**      this must be called before all other mp commands.
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      <nothing>
**
**  Returns:
**      <none>
**
*/

var isLocal = true;

//Make sure, we are actually local
var key= ds_map_find_first(global.htme_object.globalInstances);
//This will loop through all players in the player map
for(var i=0; i<ds_map_size(global.htme_object.globalInstances); i+=1) {
    var inst_id = ds_map_find_value(global.htme_object.globalInstances,key);
    if (inst_id == self.id) isLocal = false;
    key = ds_map_find_next(global.htme_object.globalInstances, key);
}
if (global.htme_object.tmp_creatingNetworkInstance) isLocal = false;

if (isLocal) {
    self.htme_mp_id = htme_hash();
    self.htme_mp_object = self.object_index;
    self.htme_mp_groups = ds_map_create();
    self.htme_mp_vars = ds_map_create();
    //Temporary variable maps for comparing against when syncing and recieving
    //with tolerance and/or IMPORTANTPLUS
    self.htme_mp_vars_sync = ds_map_create();
    
    self.htme_mp_stayAlive = false;
    self.htme_mp_player = global.htme_object.playerhash;
    ds_map_add(global.htme_object.localInstances,self.htme_mp_id,self.id);
    ds_map_add(global.htme_object.globalInstances,self.htme_mp_id,self.id);
    var v_id =self.id;
    var v_object = self.htme_mp_object;
    var v_hash =self.htme_mp_id;
    with global.htme_object {
        htme_debugger("mp_sync",htme_debug.DEBUG,"Added instance "+object_get_name(v_object)+"."+string(v_id)+" to htme! Internal hash: "+v_hash);
    }
} else {
    self.htme_mp_groups = ds_map_create();
    self.htme_mp_vars = ds_map_create();
    //Temporary variable maps for comparing against when syncing and recieving
    //with tolerance and/or IMPORTANTPLUS
    self.htme_mp_vars_recv = ds_map_create();
    self.htme_mp_vars_sync = ds_map_create();
    
    self.htme_mp_stayAlive = false;
    self.htme_mp_player = ""; //Must be overwritten!
    //Rest needs to be added upon creation#
    var v_id =self.id;
    var v_object = self.object_index;
    with global.htme_object {
        htme_debugger("mp_sync",htme_debug.DEBUG,"Added NETWORK instance "+object_get_name(v_object)+"."+string(v_id)+" to htme! Internal hash is not know yet.");
    }
}
