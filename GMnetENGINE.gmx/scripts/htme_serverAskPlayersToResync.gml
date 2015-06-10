///htme_serverAskPlayersToResync(room,except);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Asks all players in {room} (except for {except}) to resync their
**      instances with the server.
**      This shouldn't be called if the server is in the same room.
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      room    real       The room of the players that should resync
**      exlcude string     ip:port of the player to ignore
**
**  Returns:
**      <nothing>
**
*/

var playerroom = argument0;
var exclude = argument1;

htme_debugger("htme_serverAskPlayersToResync",htme_debug.DEBUG,"Asking players in room "+string(room)+" to resync everything");

buffer_seek(self.buffer, buffer_seek_start, 0);
buffer_write(self.buffer, buffer_s8, htme_packet.SERVER_PLEASE_RESYNC);

htme_sendNewSignedPacket(self.buffer,all,exclude,playerroom);
