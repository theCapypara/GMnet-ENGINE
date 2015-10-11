///htme_clientStop()

/*
**  Description:
**      This will stop the client. Please note that this will NOT reset most of the variables.
**      It will only kill the socket and mark the engine as not being started.
**      The server will not be informed, and you will time out on the server.
**      If you want to shutdown the client while informing the server
**      use htme_clientShutdown.
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
htme_debugger("htme_clientStop",htme_debug.WARNING,"STOPPING CLIENT");
htme_shutdown();
if (self.use_udphp) {
    script_execute(asset_get_index("udphp_stopClient"));
}
}
