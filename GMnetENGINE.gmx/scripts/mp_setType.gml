///mp_setType(group,type)

/*
**  Description:
**      Changes the type with which a group will be synced to the other clients
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      group    string         the name of the group of which you want to change the type
**      type     real,mp_type   The values of the enum mp_type can be seen in htme_init or 
**                              the manual
**
**  Returns:
**      <none>
**
*/

var groupname = argument0;
var type = argument1;

var group = ds_map_find_value(self.htme_mp_groups,groupname);
if (!is_undefined(group)) {
    group[? "type"] = type;
} else {
    with global.htme_object {
        htme_debugger("mp_setType",htme_debug.WARNING,"You tried to change the type of a nonexistent variable group!");
    }
}
