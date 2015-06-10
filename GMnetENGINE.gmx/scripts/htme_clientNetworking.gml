///htme_clientNetworking();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Proccesses all incoming packets, except pings, signed packets, connection packets
**      and GMnet PUNCH packets.
**      May also process packets relayed by the signed packets networking event. More information
**      can be found in the manual ( I hope :D ). Because of this the buffer pointer is NOT 
**      reset here!
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

//Check that the packet is from the server
if (in_ip == self.server_ip) {
    //Read command
    var code = buffer_read(in_buff, buffer_s8 );
    switch code {
        case htme_packet.SERVER_GREETINGS:
            //Note our playerhash and attach it to previously created instances.
            var playerhash = buffer_read(in_buff,buffer_string);
            self.playerhash = playerhash;
            ds_list_add(self.playerlist,playerhash);
            //Attach correct playerhash.
            var key= ds_map_find_first(self.localInstances);
            //This will loop through all local managed instances
            for(var i=0; i<ds_map_size(self.localInstances); i+=1) {
                var inst = ds_map_find_value(self.localInstances,key);
                with inst {
                    self.htme_mp_player = playerhash;
                    var v_id =self.id;
                    var v_object = self.htme_mp_object;
                    var v_hash =self.htme_mp_id;
                    with global.htme_object {
                        htme_debugger("htme_clientNetworking",htme_debug.DEBUG,"Updated instance "+object_get_name(v_object)+"."+string(v_id)+" local playerhash! Internal hash of instance: "+v_hash);
                    }
                }
            }
            htme_debugger("htme_clientNetworking",htme_debug.INFO,"Got greetings from server");
            //Pretend we are entering a new room
            htme_roomstart();
        break;
        case htme_packet.SERVER_PLAYERCONNECTED:
            //Do nothing apart from logging
            var playerhash = buffer_read(in_buff,buffer_string);
            //Oh, and adding him to the local playerlist.
            ds_list_add(self.playerlist,playerhash);
            htme_debugger("htme_clientNetworking",htme_debug.INFO,"Player "+playerhash+" connected.");
        break;
        case htme_packet.SERVER_PLAYERDISCONNECTED:
            //Do nothing apart from logging
            var playerhash = buffer_read(in_buff,buffer_string);
            //Oh, and adding him to the local playerlist.
            ds_list_delete(self.playerlist,ds_list_find_index(self.playerlist,playerhash));;
            htme_debugger("htme_clientNetworking",htme_debug.INFO,"Player "+playerhash+" disconnected.");
        break;
        case htme_packet.INSTANCE_VARGROUP:
            htme_debugger("htme_clientNetworking",htme_debug.DEBUG,"Got a update packet");
            htme_recieveVarGroup();
        break;
        case htme_packet.GLOBALSYNC:
            htme_debugger("htme_clientNetworking",htme_debug.DEBUG,"Got a update globalsync update");
            htme_recieveGS();
        break;
        case htme_packet.SERVER_INSTANCEREMOVED:
             var hash = buffer_read(in_buff,buffer_string);
             htme_debugger("htme_clientNetworking",htme_debug.DEBUG,"Server said, remove instance "+hash+"!");
             var inst = ds_map_find_value(self.globalInstances,hash);
             if (!is_undefined(inst) && instance_exists(inst)) {
                htme_cleanUpInstance(inst);
                {with (inst) {instance_destroy();}}
             }
             ds_map_delete(self.globalInstances,hash);
        break;
        case htme_packet.SERVER_KICKREQ:
             htme_clientDisconnect();
        break;
        case htme_packet.CHAT_API:
             var channel = buffer_read(in_buff,buffer_string);
             var to = buffer_read(in_buff,buffer_string);
             var message = buffer_read(in_buff,buffer_string);
             htme_debugger("htme_clientNetworking",htme_debug.CHATDEBUG,"CHAT API ["+channel+"] - Recieved "+message+" to "+to+".");
             
             //Add to local queues
             if (to == "" or to == self.playerhash) {
                 htme_debugger("htme_clientNetworking",htme_debug.CHATDEBUG,"CHAT API ["+channel+"] - Relaying message "+message+" to myself.");
                 htme_chatAddToQueue(channel, message, to);
             }
        break;
        case htme_packet.SERVER_PLEASE_RESYNC:
             htme_forceSyncLocalInstances(self.playerhash);
        break;
    }
}
