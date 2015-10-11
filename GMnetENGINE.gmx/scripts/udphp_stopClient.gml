///udphp_stopClient(client_id)

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
**      udphp_stopClient(client_id)
**
**  Arguments:
**      <none>
**
**  Returns:
**      <nothing>
**
*/

var client_id = argument0;

udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client_id, "Stopping client...");
if (!ds_map_exists(global.udphp_clients_udp,client_id)) {
    udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client_id, "Client not found");
    exit;
}

ds_map_delete(global.udphp_clients_udp,client_id);
ds_map_delete(global.udphp_clients_tcp,client_id);
ds_map_delete(global.udphp_clients_serverip,client_id);
ds_map_delete(global.udphp_clients_serverport,client_id);
ds_map_delete(global.udphp_clients_timeout,client_id);
ds_map_delete(global.udphp_clients_directconnect,client_id);
ds_map_delete(global.udphp_clients_connected,client_id);
udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client_id, "Client stopped...");
