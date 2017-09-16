///udphp_clientIsConnected(client)

/*
**  Description:
**      With this you can check if your client has conncted to the server.
**  
**  Usage:
**      udphp_clientIsConnected(client)
**
**  Arguments:
**      client    real    ID of the client to check
**
**  Returns:
**      true if connected or false
**
*/

var client = argument0;

if (!instance_exists(client)) {
    udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client, "Client not found");
    return false;
}

return client.connected;