///htme_serverNetworking()

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      server counterpart of htme_clientNetworking
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      <none>
**
**  Returns:
**      <nothing>
**
*/

if (!self.isConnected) {exit;}

//Set up some local variables.
var in_ip = ds_map_find_value(async_load, "ip");
var in_buff = ds_map_find_value(async_load, "buffer");
var in_id = ds_map_find_value(async_load, "id");
var in_port = ds_map_find_value(async_load, "port");

var player = ds_map_find_value(self.playermap,in_ip+":"+string(in_port));

//Check that the packet is from a valid client
if (!is_undefined(player)) {
    //Read command
    var code = buffer_read(in_buff, buffer_s8 );
    switch code {
        case htme_packet.INSTANCE_VARGROUP:
            htme_debugger("htme_serverNetworking",htme_debug.DEBUG,"Got a update packet");
            htme_recieveVarGroup();
        break;
        case htme_packet.GLOBALSYNC:
            htme_debugger("htme_serverNetworking",htme_debug.DEBUG,"Got a update globalsync update");
            htme_recieveGS();
        break;
        case htme_packet.CLIENT_INSTANCEREMOVED:
             var hash = buffer_read(in_buff,buffer_string);
             htme_debugger("htme_serverNetworking",htme_debug.DEBUG,"Player "+in_ip+":"+string(in_port)+" removed instance "+hash+"! Remove local and then broadcast!");
             var inst = ds_map_find_value(self.globalInstances,hash);
             if (!is_undefined(inst) && instance_exists(inst)) {
                htme_cleanUpInstance(inst);
                {with (inst) {instance_destroy();}}
             }
             htme_serverRemoveBackup(hash);
             ds_map_delete(self.globalInstances,hash);
             htme_serverBroadcastUnsync(hash);
        break;
        case htme_packet.CLIENT_ROOMCHANGE:
             var _room = buffer_read(in_buff,buffer_u16);
             htme_debugger("htme_serverNetworking",htme_debug.INFO,"Player "+in_ip+":"+string(in_port)+" moved to room "+string(_room)+"!");
             ds_map_replace(self.playerrooms,in_ip+":"+string(in_port),_room);
             //Tell all other players not in the room to delete their instances of this player
             //and send all instances of this player to the other players
             htme_serverBroadcastRoomChange(ds_map_find_value(self.playermap,in_ip+":"+string(in_port)));
             
             htme_serverSendAllInstances(in_ip+":"+string(in_port));
             if (room != _room) {
                 //Refresh our backup and rebroadcast stuff like positions, because this is all
                 //ooutdated if we are in another room.
                 htme_serverAskPlayersToResync(_room,in_ip+":"+string(in_port));
             }
             
        break;
        case htme_packet.CLIENT_BYE:
             htme_debugger("htme_serverNetworking",htme_debug.INFO,in_ip+":"+string(in_port)+" wants to disconnect");
             htme_serverKickClient(in_ip+":"+string(in_port));
        break;
        case htme_packet.CHAT_API:
             var channel = buffer_read(in_buff,buffer_string);
             var to = buffer_read(in_buff,buffer_string);
             var message = buffer_read(in_buff,buffer_string);
             htme_debugger("htme_serverNetworking",htme_debug.CHATDEBUG,"CHAT API ["+channel+"] - Recieved "+message+" to "+to+".");
             //Add to local queues
             if (to == "" or to == self.playerhash) {
                 htme_debugger("htme_serverNetworking",htme_debug.CHATDEBUG,"CHAT API ["+channel+"] - Relaying message "+message+" to myself.");
                 htme_chatAddToQueue(channel, message, to);
             }
             htme_chatSendServer(channel,message,to);
        break;
    }
}
