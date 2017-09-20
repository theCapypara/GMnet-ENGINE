///htme_playerMapIP(player)

/*
**  Description:
**      Get an ip out of a player map entry (see manual for more information)
**  
**  Usage:
**      <see above>
**
**  Arguments:
**      string    string    A entry from a player map in the format ip:port
**
**  Returns:
**      a string containing the ip
**
*/

return htme_string_explode(argument0,":",0);
