///mp_add(groupname,variables,datatype,interval);

/*
**  Description:
**      Adds a new group of variables to be synced to this instance.
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      groupname   string      The name of the group, this is only used locally to identify
**                              this group, for example if you want to use mp_setType
**      variables   string      A list of local variables of the instance seperated 
**                              with commas
**      datatype  real,buffer_* A value of a "buffer_" constant to specify the data type
**                              of all variables in this group.
**                              See the manual or this page
**                              http://docs.yoyogames.com/source/dadiospice/002_reference/buffers/buffer_read.html
**                              for a list of datatypes and their meanings.
**                              All datatypes from enum mp_buffer_types are also allowed but
**                              should not be used by you as a user!
**      interval    real        The interval in which the variable group get's synced with
**                              the other players
**  Returns:
**      <none>
**
*/

var groupname = argument0;
var variables = argument1;
var datatype = argument2;
var interval = argument3;

//Alternative group creation on server (if serverBackup already exists):
if (global.htme_object.tmp_creatingNetworkInstanceNoGroups) {
    var bE = ds_map_find_value(global.htme_object.serverBackup,global.htme_object.tmp_creatingNetworkInstanceHash);
    var groups = bE[? "groups"]
    var group = ds_map_find_value(groups,groupname);
    group[? "instance"] = self.id;
    ds_map_add(self.htme_mp_groups,groupname,group);
    exit;
}

var group = ds_map_create();
/** PROCESS VARIABLES **/
group[? "variables"] = ds_list_create();
var reached_end = false, last="", current, k=0;
while (!reached_end) {
    current = htme_string_explode(variables,",",k);
    if (current == last) {
        reached_end = true;
    } else {
        ds_list_add(group[? "variables"],current);
        last = current;
        k++;
    }
}
group[? "datatype"] = datatype;
group[? "type"] = mp_type.FAST;
group[? "interval"] = interval;
group[? "tolerance"] = 0;
group[? "name"] = groupname;
group[? "__counter"] = 1;

//Metadata of the instance for looping
group[? "instance"] = self.id;
if (global.htme_object.tmp_creatingNetworkInstance)
   group[? "instancehash"] = global.htme_object.tmp_creatingNetworkInstanceHash;
else
   group[? "instancehash"] = self.htme_mp_id;

//Add to list and store the list index itself in the map for removal
//BUT ONLY GLOBALLY IF SERVER!
if (global.htme_object.isServer || !global.htme_object.tmp_creatingNetworkInstance || global.htme_object.playerhash == self.htme_mp_player) {
    ds_list_add(global.htme_object.grouplist,group);
}
//ONLY LOCAL (even if server)
if (!global.htme_object.tmp_creatingNetworkInstance || global.htme_object.playerhash == self.htme_mp_player) {
    ds_list_add(global.htme_object.grouplist_local,group);
}

ds_map_add(self.htme_mp_groups,groupname,group);
var v_id =self.id;
var v_object = self.object_index;
with global.htme_object {
    htme_debugger("mp_add",htme_debug.DEBUG,"Added variable group "+groupname+" to instance "+object_get_name(v_object)+"."+string(v_id));
}
