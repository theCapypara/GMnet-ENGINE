///htme_globalGet(name);

/*
**  Description:
**      Returns a variable from the global sync list.
**      See htme_globalSet for information on what these variables are
**      Will return undefined if variables was not stored previously by any client
**      or the server.
**      Make sure the player is connected or a server is running!
**  
**  Usage:
**      <see above>
**
**  Arguments:
**      name        string   The name of the variable
**
**  Returns:
**      The saved variable (real or string) or undefined
**
*/

var name = argument0;

with global.htme_object {
     return ds_map_find_value(self.globalsync,name);
}
