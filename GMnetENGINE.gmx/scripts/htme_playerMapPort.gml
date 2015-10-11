///htme_playerMapPort(player)

/*
**  Description:
**      Get a port out of a player map entry (see manual for details)
**  
**  Usage:
**      <see above>
**
**  Arguments:
**      string    string    A entry from a player list in the format ip:port
**
**  Returns:
**      a real containing the port
**
*/

//argument0 : ip:port
return real(htme_string_explode(argument0,":",1));
