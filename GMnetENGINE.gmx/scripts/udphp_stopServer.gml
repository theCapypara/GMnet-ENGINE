///udphp_stopServer()

/*
**  Description:
**      This will "stop" a running server.
**      Stopping basicly only means that all server functions will not run anymore,
**      created tcp socket will be closed, data structures will be reset (not the player list)
**      This will also NOT destroy the buffer.
**      NOTE: After stopping you need to destroy the server instance
**  Usage:
**      udphp_stopServer()
**
**  Arguments:
**      <none>
**
**  Returns:
**      <nothing>
**
*/
udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.SERVER, 0, "Stopping server...");
if (global.udphp_server_counter == -1) {
    udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.SERVER, 0, "Server was not started.");
    exit;
}

network_destroy(global.udphp_server_udp);
global.udphp_server_udp = -1;
network_destroy(global.udphp_server_tcp);
global.udphp_server_tcp = -1;
global.udphp_server_buffer = -1;
global.udphp_server_counter = -1;
ds_map_destroy(global.udphp_server_incoming_requests);
global.udphp_server_incoming_requests = -1;
ds_map_destroy(global.udphp_server_incoming_requests2);
global.udphp_server_incoming_requests2 = -1;
global.udphp_server_players = -1;
udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.SERVER, 0, "Server stopped");
