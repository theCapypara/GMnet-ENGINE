///htme_syncInstances()

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Goes through all instances managed by the engine and syncs them if the timeout
**      has been reached.
**
**      TODO: MASSIVE CLEANUP OF INFOMATION FLOW
**          This should clean up how all of the recieve and sync var group scripts get
**          their information; without this argument flood!
**          As an example on how this should be achieved take htme_isStayAlive(hash)
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

if (!self.isConnected) exit;

//This will loop through all var groups or local var groups if client.
for(var i=0; i<ds_list_size(self.grouplist); i+=1) {
    var group = ds_list_find_value(grouplist,i);
    /** CHECK COUNTER **/
    if (group[? "__counter"] <= 0) {
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
        //TIMEOUT REACHED! Sync this group!
        //htme_debugger("htme_syncInstances",htme_debug.DEBUG,"Group "+inner_key+" of instance "+key+" hit timeout. Syncing...");
        htme_syncSingleVarGroup(group,all,inst,inst_hash,inst_object,inst_stayAlive,inst_player);
        group[? "__counter"] = group[? "interval"];
    } else {
        group[? "__counter"] = group[? "__counter"]-1;
    }
}