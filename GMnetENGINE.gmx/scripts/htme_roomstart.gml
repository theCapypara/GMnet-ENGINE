///htme_roomstart()

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Sends the current room id to the server
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

if (!self.started || !self.isConnected || self.playerhash == "") exit;

htme_debugger("htme_roomstart",htme_debug.DEBUG,"ROOMSTART triggered!");

if (!self.isServer) {
    //Creates a signed packet and sends it to the server
    buffer_seek(self.buffer, buffer_seek_start, 0);
    buffer_write(self.buffer, buffer_s8, htme_packet.CLIENT_ROOMCHANGE);
    buffer_write(self.buffer, buffer_u16, room);
    htme_sendNewSignedPacket(self.buffer,noone);
    
    htme_forceSyncLocalInstances(self.playerhash);
} else {
    htme_debugger("htme_roomstart",htme_debug.DEBUG,"Noting own room.");
    ds_map_replace(self.playerrooms,"0:0",room);
    //Tell all other players not in the room to delete their instances of this player
    htme_serverBroadcastRoomChange(self.playerhash);
    //Recreate destroyed instances that are currently only existing in backup
    htme_serverRecreateInstancesLocal();
}
