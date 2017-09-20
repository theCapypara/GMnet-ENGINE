///htme_syncVar(buffer,group,datatype,newval,varname,prevSyncMap,[addName]);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      WHEN {group}[? "type"] == mp_type.smart || self.syncForce
**      Adds {newval} to the {buffer} with the {datatype}, if it is 
**      different from the enty with the key {varname} of the {prevSyncMap} 
**      or  it doesn't exist. 
**      Addionally for all non string/bool buffer types it also checks
**      if the {newval} is greater than {varname} of the {prevSyncMap}+/- the
**      {group}[? "tolerance"]. Returns true when added.
**      ELSE:
**      Adds {newval} to the {buffer} with the {datatype} and returns true
**
**      Also adds/replaces to {prevSyncMap} in both cases.
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      See description
**      Note: The optional argument [addName] is a boolean.
**            If true, before adding the variable itself to the buffer, the
**            name of the variable as buffer_string will be added.
**            Otherwise before adding the actual entry, a boolean will be added
**            representing if this was added or not
**
**  Returns:
**      Returns 1 when added, 0 if not
**
*/

var buffer = argument[0];
var group = argument[1];
var datatype = argument[2];
var newval = argument[3];
var varname = argument[4];
var prevSyncMap = argument[5];
var addName = false;
if (argument_count > 6) addName = argument[6];

if (self.syncForce || group[? "type"] != mp_type.SMART) {
   //Simply add
   if (addName) {
       buffer_write(buffer, buffer_string, varname);
   } else {
       buffer_write(buffer, buffer_bool, true);
   }
   buffer_write(buffer, datatype, newval);
   ds_map_replace(prevSyncMap,varname,newval);
   return 1;
} else {
  //This map contains the variables as they were last sync.
  var oldval = ds_map_find_value(prevSyncMap,varname);
  //Currently ignoring tolerance, too much desync potential
  var toleranceCheck = true;
  /*
  tolerance = group[? "tolerance"];
  if (is_undefined(oldval) || datatype == buffer_string || datatype == buffer_bool) toleranceCheck = true;
  else toleranceCheck = (newval < oldval-tolerance  || newval > oldval+tolerance);
  */
  if (!is_undefined(newval) && (is_undefined(oldval) || (oldval != newval && toleranceCheck))) {
     //Add
     if (addName) {
        buffer_write(buffer, buffer_string, varname);
     } else {
        buffer_write(buffer, buffer_bool, true);
     }
     buffer_write(buffer, datatype, newval);
     ds_map_replace(prevSyncMap,varname,newval);
     return 1
  }
}
if (!addName) {
   buffer_write(buffer, buffer_bool, false);
}
return 0;
