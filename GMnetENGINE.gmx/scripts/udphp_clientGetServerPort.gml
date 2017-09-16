///udphp_clientGetServerPort(client)

/*
**  Description:
**      This will return the server port of this client and should only be used if the client is connected.
**  
**  Usage:
**      udphp_clientGetServerPort(client)
**
**  Arguments:
**      client_id    real    ID of the client to check
**
**  Returns:
**      real (port or -1 if client is not existing)
**
*/

var client = argument0;

if (!instance_exists(client)) {
    return -1;
}

return client.server_port;