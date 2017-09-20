///udphp_playerListPort(player)

/*
**  Description:
**      Get a port out of a player list entry (see serverCreate for details)
**  
**  Usage:
**      udphp_playerListIP(player)
**
**  Arguments:
**      string    string    A entry from a player list in the format ip:port
**
**  Returns:
**      a real containing the port
**
*/

//argument0 : ip:port
return real(udphp_string_explode(argument0,":",1));
