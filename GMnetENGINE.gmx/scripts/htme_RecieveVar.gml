///htme_RecieveVar(instvar,newval,tolerance,datatype);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Returns {newval} if the conditions of the {tolerance} are met in case
**      the {datatype} allows tolerance
**      Otherwise returns {instvar}
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      See description
**
**  Returns:
**      See description
**
*/

var instvar = argument0;
var newval = argument1;
var tolerance = argument2;
var datatype = argument3;

//instvar can be undefined if server
if (is_undefined(instvar))
   return newval;
if (datatype == buffer_string || datatype == buffer_bool)
   return newval;
if (newval > instvar+tolerance || newval < instvar-tolerance)
   return newval;
return instvar;
