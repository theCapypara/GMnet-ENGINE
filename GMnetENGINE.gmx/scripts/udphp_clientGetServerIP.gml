///udphp_clientGetServerIP(client)

/*
**  Description:
**      This will return the server ip of this client and should only be used if the client is connected.
**  
**  Usage:
**      udphp_clientGetServerIP(client)
**
**  Arguments:
**      client    real    ID of the client to check
**
**  Returns:
**      string (ip) or real (-1 if client is not existing)
**
*/

var client = argument0;

if (!instance_exists(client)) {
    return -1;
}

return client.server_ip;