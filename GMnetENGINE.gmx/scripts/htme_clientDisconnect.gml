///htme_clientDisconnect();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Disconnects from server
**  
**  Arguments:
**      <none>
**
**  Returns:
**      <nothing>
**
*/



if (self.isServer) {
    htme_debugger("htme_clientDisconnect",htme_debug.WARNING,"Tried to use client disconect function while running in server mode.");
    exit;
}


htme_debugger("htme_clientDisconnect",htme_debug.INFO,"Disconnecting on request.");
buffer_seek(self.buffer, buffer_seek_start, 0);
buffer_write(self.buffer, buffer_s8, htme_packet.CLIENT_BYE);
network_send_udp( self.socketOrServer, self.server_ip, self.server_port, self.buffer, buffer_tell(self.buffer) );
htme_clientStop();
