///htme_clientBroadcastUnsync(hash)

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Tells the server that a instance with the internal id has should not
**      be synced anymore. This will not remove the instance from the local
**      or global list of instances.
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      hash    string    the hash of the instance in the engine
**
**  Returns:
**      <none>
**
*/

var hash = argument0;

//Creates a signed packet and sends it to the server
buffer_seek(self.buffer, buffer_seek_start, 0);
buffer_write(self.buffer, buffer_s8, htme_packet.CLIENT_INSTANCEREMOVED);
buffer_write(self.buffer, buffer_string, hash);
htme_sendNewSignedPacket(self.buffer,noone);
