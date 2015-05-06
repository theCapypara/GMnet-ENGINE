///htme_chatSendServer(channel,message,to)

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Send own or relayed message over a specified channel using the CHAT API to the right
**      clients.
**
**      Do not use this function yourself.
**
**  Usage:
**      <See above>
**
**  Arguments:
**      channel         string          The channel to send on
**      message         string          The message to send
**      to              string          Hash of the player that the message should be sent
**                                      to. "" for all.
**
**  Returns:
**      <none>
**
*/

var channel = argument0;
var message = argument1;
var to = argument2;

var cmd_list = ds_list_create();
ds_list_add(cmd_list,buffer_s8,htme_packet.CHAT_API);
ds_list_add(cmd_list,buffer_string,channel);
ds_list_add(cmd_list,buffer_string,to);
ds_list_add(cmd_list,buffer_string,message);

if (to == "") {
    //Send to all clients
    var from = htme_ds_map_find_key(self.playermap,htme_chatGetSender(message));
    if (is_undefined(from)) {
        ds_map_destroy(cmd_list);
        htme_debugger("htme_chatSendServer",htme_debug.WARNING,"CHAT API ["+channel+"] - TRIED SENDING MESSAGE FROM INVALID PLAYER "+from+" (message: "+message+".");
        exit;
    }
    htme_debugger("htme_chatSendServer",htme_debug.CHATDEBUG,"CHAT API ["+channel+"] - Sending or relaying message "+message+" to all, except the sender.");
    htme_createSignedPacket(cmd_list,all,htme_hash(),from);
} else {
    var ip_port = htme_ds_map_find_key(self.playermap,to);
    if (is_undefined(ip_port)) {
        ds_map_destroy(cmd_list);
        htme_debugger("htme_chatSendServer",htme_debug.WARNING,"CHAT API ["+channel+"] - Tried sending a message to invalid player "+to+".");
        exit;
    }
    htme_createSignedPacket(cmd_list,ip_port,htme_hash());
    htme_debugger("htme_chatSendServer",htme_debug.CHATDEBUG,"CHAT API ["+channel+"] - Sending or relaying message "+message+" to "+to+".");
}
