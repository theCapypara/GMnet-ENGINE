///mp_map_syncIn(varName, variable)

/*
**  Description:
**      Stores the variable inside the engine for syncronization. varName
**      has to be the name of the variable {variable}.
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      varName    string     name of the variable to store
**      variable   any        value of that variable
**
**  Returns:
**      <nothing>
**
*/

ds_map_replace(self.htme_mp_vars,argument0,argument1);
