///htme_networking()

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      This should be called in the networking event, it runs the networking logic required for the engine
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

if (self.started) {
    if (self.isServer) {
        ///SERVER
        if (self.use_udphp) {
            script_execute(asset_get_index("udphp_serverNetworking"));
            htme_serverSyncPlayersUDPHP();
        } else {
            htme_serverConnectNetworking();
        }
        htme_serverCheckConnectionsNetworking();
        //This needs to be done here, because the Networking functions may be called by
        //the signedPacket Networking function which moves the pointer ahead one, so we
        //can't do buffer_seek inside the Networking functions of client/server
        buffer_seek(ds_map_find_value(async_load, "buffer"), buffer_seek_start, 0);
        htme_serverNetworking(ds_map_find_value(async_load, "buffer"));
    } else {
        ///CLIENT
        if (self.use_udphp) {
            script_execute(asset_get_index("udphp_clientNetworking"),self.udphp_client_id);
        } else {
            htme_clientConnectNetworking();
        }
        htme_clientCheckConnectionNetworking();
        buffer_seek(ds_map_find_value(async_load, "buffer"), buffer_seek_start, 0);
        htme_clientNetworking(ds_map_find_value(async_load, "buffer"));
    }
    htme_recieveSignedPackets();
}
