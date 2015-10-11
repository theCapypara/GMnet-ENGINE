///htme_syncGroupNow(sync group name)

with obj_htme
{
    if (!self.isConnected) exit;
    
    //This will loop through all var groups or local var groups if client.
    for(var i=0; i<ds_list_size(self.grouplist_local); i+=1) {
        var group = ds_list_find_value(grouplist_local,i);
        // Set to sync the group now
        if group[? "name"]=argument0
        {
            group[? "__counter"] = 0;
        }      
    }
}
