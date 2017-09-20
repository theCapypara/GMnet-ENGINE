///htme_commitData()

/*
**  Description:
**      GMnet PUNCH must be enabled and a server must be running!!
**      Sends the 7 data strings to the master server to update them for the
**      lobby. This only has to be done, if the server is not already connected
**      to the master server.
**      The server might reconnect to the master server once in a while, data
**      is also updated then!
**      The gamename is also synced
**      Alias for udphp_serverCommitData();
**  Usage:
**      <see above>
**
**  Arguments:
**      <none>
**
**  Returns:
**      <nothing>
**
*/

with (global.htme_object) {
    if (self.use_udphp) {
       script_execute(asset_get_index("udphp_serverCommitData"));
    }
}
