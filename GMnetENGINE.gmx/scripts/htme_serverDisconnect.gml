///htme_serverDisconnect(playerhash);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Asks a client to execute htme_clientDisconnect to disconnect
**  
**  Arguments:
**      playerhash     string   The hash/id of the player
**
**  Returns:
**      <nothing>
**
*/

if (!self.isServer) {
    htme_debugger("htme_serverDisconnect",htme_debug.WARNING,"Tried to use server disconect function while running in client mode.");
    exit;
}

var player = argument0;

var key= ds_map_find_first(self.playermap);
for(var i=0; i<ds_map_size(self.playermap); i+=1) {
    var hash = ds_map_find_value(self.playermap,key);
    if (hash == player) {
       if (!ds_map_exists(self.kickmap, key)) {
           //Send request
           htme_debugger("htme_serverDisconnect",htme_debug.INFO,"Kicking player "+player+". Player has "+string(self.global_timeout)+"steps to disconnect");
           buffer_seek(self.buffer, buffer_seek_start, 0);
           buffer_write(self.buffer, buffer_s8, htme_packet.SERVER_KICKREQ)
           htme_sendNewSignedPacket(self.buffer,key);
           ds_map_add(self.kickmap, key, self.global_timeout);
       } else {
           htme_debugger("htme_serverDisconnect",htme_debug.WARNING,"Tried to kick a player "+player+" that had a kick already pending.");
       }
       exit;
    }
    key = ds_map_find_next(self.playermap, key);
}
htme_debugger("htme_serverDisconnect",htme_debug.WARNING,"Player "+player+" not found.");
