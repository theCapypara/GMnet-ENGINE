///htme_debugoverlay_createMicro(player_hash,object_id,instanceid,instancehash,isVisible,isExisting);
/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Returns a small string with instance information provided by the arguments
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      <see above>
**
**  Returns:
**      String with information
**
*/

var player_hash = argument0;
var object_id = object_get_name(argument1);
var iid = string(argument2);
var hash = argument3;
var isVisisble = argument4;
var isExisting = argument5;

var str =  hash

if (player_hash == self.playerhash) {
   str = str+ " (LOCAL)";
}
if (!isExisting) {
   str = str+ " (CACHED)";
}
if (!isVisisble) {
   str = str+ " (INVISIBLE)";
}
str = str + "#"
+ "PLAYER:  " + player_hash + "#"
+ "OBJECT:  " + object_id  + "#" 
+ "INST-ID:  " + iid;

return str
