//htme_serverRemoveBackup(hash);

/*
**  Description:
**      Removes the backup of this instance. Make sure the instance is removed
**      from the engine!
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      hash    string      hash identifier of the instance
**
**  Returns:
**      <none>
**
*/

var instancehash = argument0;
var backupEntry = ds_map_find_value(self.serverBackup,instancehash);
if (!is_undefined(backupEntry)) {

    //Clean up groups -> {entry} -> variables and remove from list
     var key= ds_map_find_first(backupEntry[? "groups"]);
     for(var i=0; i<ds_map_size(backupEntry[? "groups"]); i+=1) {
         var group = ds_map_find_value(backupEntry[? "groups"],key);
         if (ds_exists(group,ds_type_map)) {
             var list_ind = ds_list_find_index(self.grouplist,group);
             if (list_ind != -1)
                ds_list_delete(self.grouplist,list_ind);
             ds_map_destroy(group);
         }
         key = ds_map_find_next(backupEntry[? "groups"], key);
     }

   ds_map_destroy(backupEntry[? "groups"]);
   ds_map_destroy(backupEntry[? "backupVars"]);
   ds_map_destroy(backupEntry[? "syncVars"]);
   ds_map_destroy(backupEntry);
   ds_map_delete(self.serverBackup,instancehash);
}
