///udphp_serverCommitData()

/*
**  Description:
**      Sends the 8 data strings to the master server to update them for the
**      lobby. This only has to be done, if the server is not already connected
**      to the master server.
**      The server might reconnect to the master server once in a while, data
**      is also updated then!
**  Usage:
**      udphp_serverCommitData()
**
**  Arguments:
**      <none>
**
**  Returns:
**      <nothing>
**
*/

/// CHECK IF SERVER IS RUNNING (we can use any server-releated variable for that; we assume they don't get changed from outside)
if (global.udphp_server_counter == -1) {
    udphp_handleerror(udphp_dbglvl.WARNING, udphp_dbgtarget.SERVER, 0, "Server was not started.");
    exit;
}

var buffer = global.udphp_server_buffer;
var server_tcp = global.udphp_server_tcp;

//Force re-registration
global.udphp_server_counter = -1;
network_destroy(server_tcp);

udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.SERVER, 0, "Updated data string for master server");
