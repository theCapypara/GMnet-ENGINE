///htme_syncInstances()

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Goes through all instances managed by the engine and syncs them if the timeout
**      has been reached.
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

//EXPERIMENTAL: Server: Relay instantly, instead of looping over it. -
// See htme_serverRecieveVarGroup 
//This will loop through all var groups or local var groups if client.
for(var i=0; i<ds_list_size(self.grouplist_local); i+=1) {
    var group = ds_list_find_value(grouplist_local,i);
    /** CHECK COUNTER **/
    if (group[? "__counter"] <= 0) {
        //TIMEOUT REACHED! Sync this group!
        htme_syncSingleVarGroup(group,all);
        group[? "__counter"] = group[? "interval"];
    } else {
        group[? "__counter"] = group[? "__counter"]-1;
    }
}
