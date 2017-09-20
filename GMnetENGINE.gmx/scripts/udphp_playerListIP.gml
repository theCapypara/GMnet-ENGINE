///udphp_playerListIP(player)

/*
**  Description:
**      Get an ip out of a player list entry (see serverCreate for details)
**  
**  Usage:
**      udphp_playerListIP(player)
**
**  Arguments:
**      string    string    A entry from a player list in the format ip:port
**
**  Returns:
**      a string containing the ip
**
*/

return udphp_string_explode(argument0,":",0);
