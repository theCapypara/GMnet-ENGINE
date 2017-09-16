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

// Clean others
if ds_exists(global.udphp_downloadlist_topmap,ds_type_map) {
    ds_map_destroy(global.udphp_downloadlist_topmap);
    global.udphp_downloadlist_topmap=-1;
}
if ds_exists(global.udphp_downloadlist,ds_type_list) {
    ds_list_destroy(global.udphp_downloadlist);
    global.udphp_downloadlist=-1;
}
if ds_exists(global.udphp_clients,ds_type_map) {
    ds_map_destroy(global.udphp_clients);
    global.udphp_clients=-1;
}

// Check if object exists
if client>-1 {
    with (client) {instance_destroy();}
}
udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.CLIENT, client, "Client stopped...");