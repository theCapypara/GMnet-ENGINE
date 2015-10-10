///htme_serverEventPlayerConnected(ip,port);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      This will register a new player, tell him his playerhash and send a PLAYER_CONNECTED
**      packet to all players
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      ip       string      ip of the new player
**      port     real        port that the new player connected on
**
**  Returns:
**      <nothing>
**
*/


var ip = argument0;
var port = argument1;

htme_debugger("htme_serverEventPlayerConnected",htme_debug.DEBUG,"Handling connection for "+ip+":"+string(port)+"...");

//EVENT HANDLER - PLAYER CONNECTED
var ev_map = ds_map_create();
ev_map[? "ip"] = ip;
ev_map[? "port"] = port;
if (!script_execute(self.serverEventHandlerConnect,ev_map)) {
    //CONNECTION REFUSED
    htme_debugger("htme_serverEventPlayerConnected",htme_debug.INFO,"Connection for "+ip+":"+string(port)+" refused. Player will be disconnected.");   
    buffer_seek(self.buffer, buffer_seek_start, 0);
    buffer_write(self.buffer, buffer_s8, htme_packet.SERVER_KICKREQ)
    network_send_udp( self.socketOrServer, ip, port, self.buffer, buffer_tell(self.buffer) );
    ds_map_destroy(ev_map);
    if (self.use_udphp) {
        //Remove from udphp player list
        var pos = ds_list_find_index(self.udphp_playerlist,ip+":"+string(port));
        if (pos != -1)
            ds_list_delete(self.udphp_playerlist,pos);
    }
    exit;
}
ds_map_destroy(ev_map);
var player = ip+":"+string(port);
var playerhash = htme_hash();
//Now we extend the playerhash with the player number.
var players = global.htme_object.playerlist;
var checker = ds_map_create();
for (var i = 0; i<ds_list_size(players); i++) {
    var num = htme_string_explode(players[| i],"-",1);
    ds_map_add(checker,real(num),1);
}
var found = false;
var i = 1;
while (!found) {
    if (is_undefined(ds_map_find_value(checker,i))) {
       found = true;
       playerhash = playerhash+"-"+string(i);
    }
    i++;
}
ds_map_destroy(checker);
//END OF Now we extend the playerhash with the player number.

htme_debugger("htme_serverEventPlayerConnected",htme_debug.INFO,"CONNECTED TO CLIENT "+player+" . Adding to the playermap with hash "+playerhash);


//Add player to server playermap.
ds_map_add(self.playermap,player,playerhash);
//And also to playerlist
ds_list_add(self.playerlist,playerhash);


//Tell the player he is connected.
buffer_seek(self.buffer, buffer_seek_start, 0);
buffer_write(self.buffer, buffer_s8, htme_packet.SERVER_GREETINGS);
buffer_write(self.buffer, buffer_string, playerhash);
//Send
htme_debugger("htme_serverEventPlayerConnected",htme_debug.DEBUG,"Create signed packet to tell player he is connected");
htme_sendNewSignedPacket(self.buffer,player);

//Tell the others that he connected
buffer_seek(self.buffer, buffer_seek_start, 0);
buffer_write(self.buffer, buffer_s8, htme_packet.SERVER_PLAYERCONNECTED);
buffer_write(self.buffer, buffer_string, playerhash);
//Send
htme_debugger("htme_serverEventPlayerConnected",htme_debug.DEBUG,"Tell other clients the good news!");
htme_sendNewSignedPacket(self.buffer,all,player);

//Send global sync list
htme_sendGS(player,all);

//Do not send all instances, instead wait for room anncouncement
