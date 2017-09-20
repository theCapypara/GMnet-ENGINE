///mp_tolerance(groupname,tolerance)

/*
**  Description:
**      If a tolerance is set, a change in the variables sent via network will
**      only be applied locally if the change is greater than the tolerance.
**      This can be used to make the player not jump all over the place when
**      his position is just slightly out of sync, which make your game look
**      much smoother. 
**      This can be used if the buffer type set for this group is not buffer_bool
**      or buffer_string, otherwise errors will occur.
**      This can also be used with all preset mp_add* functions 
**      (e.g. mp_addPosition)
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      groupname   string       the name of the previously added group
**      tolerance   real         the tolerance to apply
**
**  Returns:
**      <nothing>
**
*/

var groupname = argument0;
var tolerance = argument1;

var group = ds_map_find_value(self.htme_mp_groups,groupname);
if (!is_undefined(group)) {
    group[? "tolerance"] = tolerance;
} else {
    with global.htme_object {
        htme_debugger("mp_tolerance",htme_debug.WARNING,"You tried to change the tolerance of a nonexistent variable group!");
    }
}
