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
    htme_debugger("udphp_clientIsConnected", htme_debug.DEBUG, "Client not found", true);
    return false;
}

return client.connected;
