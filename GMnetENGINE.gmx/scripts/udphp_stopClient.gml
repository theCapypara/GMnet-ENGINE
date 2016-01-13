///udphp_stopClient(client)

/*
**  Description:
**      This will "stop" a running client.
**      Stopping basicly only means that all server functions will not run anymore,
**      created tcp socket will be closed, data structures will be reset (not the player list)
**      This will also NOT destroy the buffer.
**      NOTE: After stopping you don't need to delete the client instance. clientPunch will return false now
**      for this client. Remove the client instance in it's step event.
**  
**  Usage:
**      udphp_stopClient(client)
**
**  Arguments:
**      <none>
**
**  Returns:
**      <nothing>
**
*/

var client = argument0;

udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client, "Stopping client...");
if (!instance_exists(client)) {
    udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client, "Client not found");
    exit;
}

with (client) {instance_destroy();}
udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client, "Client stopped...");
