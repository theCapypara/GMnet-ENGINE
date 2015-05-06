///htme_serverProcessKicks();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Broadcast Server information to the LAN
**  
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
if (self.lan_intervalpnt >= self.lan_interval) {
    buffer_seek(self.buffer, buffer_seek_start, 0);
    buffer_write(self.buffer, buffer_s8, htme_packet.SERVER_BROADCAST);
    buffer_write(self.buffer, buffer_string, htme_getDataServer(1));
    buffer_write(self.buffer, buffer_string, htme_getDataServer(2));
    buffer_write(self.buffer, buffer_string, htme_getDataServer(3));
    buffer_write(self.buffer, buffer_string, htme_getDataServer(4));
    buffer_write(self.buffer, buffer_string, htme_getDataServer(5));
    buffer_write(self.buffer, buffer_string, htme_getDataServer(6));
    buffer_write(self.buffer, buffer_string, htme_getDataServer(7));
    buffer_write(self.buffer, buffer_string, htme_getDataServer(8));
    network_send_broadcast(self.socketOrServer, self.port+1, self.buffer, buffer_tell(self.buffer));
    self.lan_intervalpnt = 0;
} else {
    self.lan_intervalpnt++;
}
