///htme_serverBroadcastUnsync(hash,[target])

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Tells all clients that a instance with the internal id has should not
**      be synced anymore. This will not remove the instance from the local
**      or global list of instances.
**  
**  Usage:
**      hash           string    the hash of the instance in the engine
**      [target]       string    ip:port, if not given, this will be sent to all
**
**  Arguments:
**      <nothing>
**
**  Returns:
**      <none>
**
*/

var hash = argument[0];

//Creates a signed packet and sends it
buffer_seek(self.buffer, buffer_seek_start, 0);
buffer_write(self.buffer, buffer_s8, htme_packet.SERVER_INSTANCEREMOVED);
buffer_write(self.buffer, buffer_string, hash);

if (argument_count > 1) {
   htme_sendNewSignedPacket(self.buffer,argument[1]);
} else {
   htme_sendNewSignedPacket(self.buffer,all);
}
