///mp_map_syncOut(varName, variable)

/*
**  Description:
**      Returns the value of varName in the variable map of this instance to
**      sync the variable map of the engine to the instance.
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      varName    string     name of the variable to get
**      variable   any        value of the variable that the instance currently
**                            has. Will later be used to compare them to
**                            values in the engine. Currently this is returned
**                            if the engine has no valid data for this varName.
**
**  Returns:
**      value of varName in the variable map of this instance
**
*/

var v = ds_map_find_value(self.htme_mp_vars,argument0);
if (!is_undefined(v)) {
   return v;
} else {
  return argument1;
}
