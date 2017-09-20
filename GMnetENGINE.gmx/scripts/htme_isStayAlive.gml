///htme_isStayAlive(hash)

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Returns of an eninge instance is configured to be in stayAlive mode.
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      hash    string                hash of the instance
**
**  Returns:
**      <Nothing>
**
*/
var inst = ds_map_find_value(self.globalInstances,argument0);
if (instance_exists(inst)) {
    return (inst).htme_mp_stayAlive;
} else if (self.isServer && ds_map_exists(self.serverBackup,argument0)) {
    var backupEntry = ds_map_find_value(self.serverBackup,argument0);
    return backupEntry[? "stayAlive"];
}
else return false;
