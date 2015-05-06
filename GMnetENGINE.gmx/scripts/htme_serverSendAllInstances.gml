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

//This will loop through all var groups.
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
    //Don't send own!
    if (inst_player == self.playerhash) {continue;}
    htme_syncSingleVarGroup(group,target,inst,inst_hash,inst_object,inst_stayAlive,inst_player);
}

self.syncForce = false;