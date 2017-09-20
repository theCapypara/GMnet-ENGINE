///htme_serverSendBufferToAllExcept(buffer,exclude,[checkroom])

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Sends the current buffer to all players, but not the one thats excluded
**  
**  Usage:
**      buffer      real               The buffer to send
**      exclude     string             ip:port
**      checkroom   room id (real)     if given, the packet will only be sent
**                                     to players who are in that room according
**                                     to the playerroom map
**
**  Arguments:
**      <None>
**
**  Returns:
**      <Nothing>
**
*/
var send_buffer = argument[0];
var exclude = argument[1];

var key= ds_map_find_first(self.playermap);
//This will loop through all players in the player map
for(var i=0; i<ds_map_size(self.playermap); i+=1) {
    //Skip local player
    if (key == "0:0") {key = ds_map_find_next(self.playermap, key);continue;}   
    //Skip if exclude
    if (key == exclude) {key = ds_map_find_next(self.playermap, key);continue;}   
    //check if in room
    if (argument_count > 2) {
       if (!htme_serverPlayerIsInRoom(key,argument[2])) {key = ds_map_find_next(self.playermap, key);continue;}
    }
    //Send a SignedPacket to all players
    var ip = htme_playerMapIP(key);
    var port = htme_playerMapPort(key);
    network_send_udp( self.socketOrServer, ip, port, send_buffer, buffer_tell(send_buffer) );
    key = ds_map_find_next(self.playermap, key);
}
