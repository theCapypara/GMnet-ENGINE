///htme_globalSetFast(name,value,datatype);

/*
**  Description:
**      Like htme_globalSet but using the FAST sync type.
**  
**  Usage:
**      <see above>
**
**  Arguments:
**      name        string        The name of the variable
**      value       real/string   The (new) value of the variable you want to
**                                store
**      datatype    real          See mp_add
**
**  Returns:
**      <nothing>
**
*/

var name = argument0;
var value = argument1;
var datatype = argument2;

htme_debugger("htme_globalSetFast",htme_debug.DEBUG,"Global Sync: Setting "+name+" to "+string(value));

with global.htme_object {

    ds_map_replace(self.globalsync,name,value);
    ds_map_replace(self.globalsync_datatypes,name,datatype);
    
    if (self.isServer) {
       htme_sendGSFast(all,name);
    } else {
       htme_sendGSFast(noone,name);
    }

}
