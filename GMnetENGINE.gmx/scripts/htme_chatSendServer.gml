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

buffer_seek(self.buffer, buffer_seek_start, 0);
buffer_write(self.buffer, buffer_s8,htme_packet.CHAT_API);
buffer_write(self.buffer, buffer_string,channel);
buffer_write(self.buffer, buffer_string,to);
buffer_write(self.buffer, buffer_string,message);

if (to == "") {
    //Send to all clients
    var from = htme_ds_map_find_key(self.playermap,htme_chatGetSender(message));
    if (is_undefined(from)) {
        htme_debugger("htme_chatSendServer",htme_debug.WARNING,"CHAT API ["+channel+"] - TRIED SENDING MESSAGE FROM INVALID PLAYER "+from+" (message: "+message+".");
        exit;
    }
    htme_debugger("htme_chatSendServer",htme_debug.CHATDEBUG,"CHAT API ["+channel+"] - Sending or relaying message "+message+" to all, except the sender.");
    htme_sendNewSignedPacket(self.buffer,all,from);
} else {
    var ip_port = htme_ds_map_find_key(self.playermap,to);
    if (is_undefined(ip_port)) {
        htme_debugger("htme_chatSendServer",htme_debug.WARNING,"CHAT API ["+channel+"] - Tried sending a message to invalid player "+to+".");
        exit;
    }
    htme_sendNewSignedPacket(self.buffer,ip_port);
    htme_debugger("htme_chatSendServer",htme_debug.CHATDEBUG,"CHAT API ["+channel+"] - Sending or relaying message "+message+" to "+to+".");
}
