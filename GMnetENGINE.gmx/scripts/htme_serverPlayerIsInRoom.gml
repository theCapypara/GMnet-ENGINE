///htme_serverPlayerIsInRoom(player,troom);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      This checks if the player is in the room according to the playerroom map
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      player     string         ip:port
**      room       real (roomid)
**
**  Returns:
**      true if in same room, false if not
**
*/

var player = argument0;
var troom = argument1;

var real_room = ds_map_find_value(self.playerrooms,player);
if (is_undefined(real_room)) return false;
return (real_room == troom);
