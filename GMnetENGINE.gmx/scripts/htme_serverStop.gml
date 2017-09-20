///htme_serverStop()

/*
**  Description:
**      This will stop the server. Please note that this will NOT reset most of the variables.
**      It will only kill the socket and mark the engine as not being started. All players connected
**      will timeout.
**      If you want to shutdown the server while sending all players a goodbye, 
**      use htme_serverShutdown.
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      <None>
**
**  Returns:
**      <Nothing>
**
*/
with (global.htme_object) {
htme_debugger("htme_serverStop",htme_debug.WARNING,"STOPPING SERVER");
htme_shutdown();
if (self.use_udphp) {
    script_execute(asset_get_index("udphp_stopServer"));
}
}
