///htme_serverCheckConnections();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      This script checks if any of the clients is unreachable via ping-tests. 
**      If so, the player will be disconnected. 
**      The ping packets get send every {timeout}/2 seconds and the server will wait
**      {timeout} seconds for an answer.
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

var key= ds_map_find_first(self.playermap);
//This will loop through all players in the player map
for(var i=0; i<ds_map_size(self.playermap); i+=1) {
    //Skip local player
    if (key == "0:0") {key = ds_map_find_next(self.playermap, key);continue;}
    
    var player = ds_map_find_value(self.playermap,key);
    var timeoutSend = ds_map_find_value(self.serverTimeoutSend,key);
    if (is_undefined(timeoutSend)) {
        ds_map_add(self.serverTimeoutSend,key,self.global_timeout/2);
        timeoutSend = self.global_timeout/2;
    }
    var timeoutRecv = ds_map_find_value(self.serverTimeoutRecv,key);
    if (is_undefined(timeoutRecv)) {
        ds_map_add(self.serverTimeoutRecv,key,self.global_timeout);
        timeoutRecv = self.global_timeout;
    }
    var ip = htme_playerMapIP(key);
    var port = htme_playerMapPort(key);
    
    
    if (timeoutSend < 0) {
        //Send ping packet
        htme_debugger("htme_serverCheckConnections",htme_debug.DEBUG,"SERVER: pinging "+ip+":"+string(port)+"...");
        buffer_seek(self.buffer, buffer_seek_start, 0);
        buffer_write(self.buffer, buffer_s8, htme_packet.PING );
        network_send_udp( self.socketOrServer, ip, port, self.buffer, buffer_tell(self.buffer) );
    }
    if (timeoutSend < -self.global_timeout/4) {
        timeoutSend = self.global_timeout/4;
    }
    if (timeoutRecv < 0) {
        //Ping failed, packet didn't reach us in time.
        htme_debugger("htme_serverCheckConnection",htme_debug.WARNING,"SERVER: PING FAILED! Disconnecting "+ip+":"+string(port)+"!");
        htme_serverKickClient(key);
        //FIXME: We can't check any other clients this step, because the loop is now brocken
        exit;
    }
    ds_map_replace(self.serverTimeoutSend,key, timeoutSend-1);
    ds_map_replace(self.serverTimeoutRecv,key, timeoutRecv-1);
    key = ds_map_find_next(self.playermap, key);
}
