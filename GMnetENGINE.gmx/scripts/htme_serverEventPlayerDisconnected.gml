//htme_serverEventPlayerDisconnected(ip_port);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      This will tell all connected players to destroy the instances of the player
**      given in the argument
**      CALL THIS BEFORE REMOVING!
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      ip:port     string        ip and port combination as stored in the playermap.
**
**  Returns:
**      <nothing>
**
*/


var pip = htme_playerMapIP(argument0);
var pport = htme_playerMapPort(argument0);
var phash = ds_map_find_value(self.playermap,argument0);

//Custom event handler
var ev_map = ds_map_create();
ev_map[? "ip"] = pip
ev_map[? "port"] = pport;
ev_map[? "hash"] = phash;
script_execute(self.serverEventHandlerDisconnect,ev_map);
ds_map_destroy(ev_map);

var mapToUse = self.globalInstances;
var key= ds_map_find_first(mapToUse);
//This will loop through all global instances
for(var i=0; i<ds_map_size(mapToUse); i+=1) {
    var inst = ds_map_find_value(mapToUse,key);
    //Use backup here, direct access is not safe!
    var backupEntry = ds_map_find_value(self.serverBackup,key);
    if (is_undefined(backupEntry)) {
       var instplayer = (inst).htme_mp_player;
    } else {
       var instplayer = backupEntry[? "player"];
    }
    //Check if instance belongs to player
    if (instplayer == phash) {
       htme_serverBroadcastUnsync(key);
       htme_cleanUpInstance(inst);
       htme_serverRemoveBackup(key);
       with (inst) {instance_destroy();}
       ds_map_delete(self.globalInstances,key);
       //We need to reset the key
       key = ds_map_find_first(mapToUse);
    } else {
        key = ds_map_find_next(mapToUse, key);
    }
}

//Also send a proper disconnection packet
buffer_seek(self.buffer, buffer_seek_start, 0);
buffer_write(self.buffer, buffer_s8, htme_packet.SERVER_PLAYERDISCONNECTED)
buffer_write(self.buffer, buffer_string, phash)
htme_sendNewSignedPacket(self.buffer,all,argument0);

htme_debugger("htme_serverEventPlayerDisconnected",htme_debug.DEBUG,"Tell other clients the bad news of "+phash+"'s disconnection!");

//Remove from playerLIST, has to be removed from map outside this event!!!
ds_list_delete(self.playerlist,ds_list_find_index(self.playerlist,phash));
