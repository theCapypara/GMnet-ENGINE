///htme_step()

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      This should be called in the step event, it runs the step logic required for the engine
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
            script_execute(asset_get_index("udphp_serverPunch"))
        }
        htme_serverCheckConnections();
        htme_serverProcessKicks();
        htme_serverBroadcast();
        htme_syncInstances();
    } else {
        ///CLIENT
        if (self.use_udphp && !self.isConnected) {
            if(!script_execute(asset_get_index("udphp_clientPunch"),self.udphp_client_id)) {
                //When this returns false, the connection failed or the client was destroyed.
                htme_debugger("htme_step",htme_debug.INFO,"CLIENT: GMnet PUNCH client is dead - connection propably failed.");
                htme_clientStop();
            } else {
                self.isConnected = script_execute(asset_get_index("udphp_clientIsConnected"),self.udphp_client_id);
                //Update server port if connected
                if (self.isConnected) {
                   self.server_port = script_execute(asset_get_index("udphp_clientGetServerPort"),self.udphp_client_id);
                }
            }
        } else if (self.isConnected && self.playerhash = "") {
            //We are connected, but the playerhash is unknown. Send request to the server
            //to get the GREETINGS message
            buffer_seek(self.buffer, buffer_seek_start, 0);
            buffer_write(self.buffer, buffer_s8, htme_packet.SIGNEDPACKET_NEW_CMD);
            buffer_write(self.buffer, buffer_s8, htme_packet.SIGNEDPACKET_NEW_CMD_REQ);
            buffer_write(self.buffer, buffer_u32, 0);
            network_send_udp( self.socketOrServer, self.server_ip, self.server_port, self.buffer, buffer_tell(self.buffer));
        } else {
            htme_clientConnect();
        }
        if (htme_clientCheckConnection()) {
            htme_syncInstances();
        }
    }
}

///Process debug overlay keypresses
if (htme_debugOverlayEnabled()) {
    if (keyboard_lastkey >= vk_f1 && keyboard_lastkey <= vk_f12) {
        if (self.dbgstate == keyboard_lastkey) self.dbgstate = vk_nokey; 
        else self.dbgstate = keyboard_lastkey; 
        keyboard_lastkey = -1;
        self.dbgpage = 0;
        self.dbgcntx = "";
        self.dbgcntx2 = "";
    }
    if (keyboard_lastkey == vk_pageup) {
        self.dbgpage = self.dbgpage - 1;
        keyboard_lastkey = -1;
    }
    if (keyboard_lastkey == vk_pagedown) {
        self.dbgpage = self.dbgpage + 1;
        keyboard_lastkey = -1;
    }
}
