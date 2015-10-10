///htme_clientCheckConnection();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      This script checks if the server is reachable via ping-tests. If not, the engine will
**      shutdown. The Check packets get send every {timeout}/2 seconds and the client will wait
**      {timeout} seconds for an answer.
**  
**  Usage:
**      <see above>
**
**  Arguments:
**      <none>
**
**  Returns:
**      true if still connected, false if not
**
*/

if (!self.isConnected) {exit;}

if (self.clientTimeoutSend < 0) {
    //Send ping packet
    htme_debugger("htme_clientCheckConnection",htme_debug.DEBUG,"CLIENT: pinging...");
    buffer_seek(self.buffer, buffer_seek_start, 0);
    buffer_write(self.buffer, buffer_s8, htme_packet.PING );
    network_send_udp( self.socketOrServer, self.server_ip, self.server_port, self.buffer, buffer_tell(self.buffer) );
}
if (self.clientTimeoutSend < -self.global_timeout/4) {
    self.clientTimeoutSend = self.global_timeout/4;
}
if (self.clientTimeoutRecv < 0) {
    //Ping failed, packet didn't reach us in time.
    htme_debugger("htme_clientCheckConnection",htme_debug.ERROR,"CLIENT: PING FAILED! Closing client!");
    htme_clientStop();
    return false;
}

self.clientTimeoutSend--;
self.clientTimeoutRecv--;
return true;
