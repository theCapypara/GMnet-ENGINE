///udphp_clientIsConnected(client_id)

/*
**  Description:
**      With this you can check if your client has conncted to the server.
**  
**  Usage:
**      udphp_clientIsConnected(client_id)
**
**  Arguments:
**      client_id    real    ID of the client to check
**
**  Returns:
**      true if connected or false
**
*/

var client_id = argument0;

if (!ds_map_exists(global.udphp_clients_udp,client_id)) {
    udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client_id, "Client not found");
    return false;
}

return ds_map_find_value(global.udphp_clients_connected,client_id);
