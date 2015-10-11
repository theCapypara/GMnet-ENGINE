///udphp_clientGetServerIP(client_id)

/*
**  Description:
**      This will return the server ip of this client and should only be used if the client is connected.
**  
**  Usage:
**      udphp_clientGetServerIP(client_id)
**
**  Arguments:
**      client_id    real    ID of the client to check
**
**  Returns:
**      string (ip) or real (-1 if client is not existing)
**
*/

var client_id = argument0;

return ds_map_find_value(global.udphp_clients_serverip,client_id);
