///htme_chatSend(channel,message,[to])

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Send message over a specified channel using the CHAT API.
**
**      For more information see mp_chatSend. Using mp_chatSend function instead of this
**      function is recommended.
**
**  Usage:
**      <See above>
**
**  Arguments:
**      channel         string          The channel to send on
**      message         string          The message to send
**      [to]            string          (optional; Will send to all by default)
**                                      hash of the player that the message should be sent
**                                      to.
**
**  Returns:
**      <none>
**
*/

var channel = argument[0];
var message = self.playerhash+chr(31)+argument[1];
var to = "";
if (argument_count > 2) {
    to = argument[2];
}

//Add to local queues
if (to == "" or to == self.playerhash) {
    htme_debugger("htme_chatSend",htme_debug.CHATDEBUG,"CHAT API ["+channel+"] - Sending message "+message+" to myself.");
    htme_chatAddToQueue(channel, message, to);
}

if (to == self.playerhash) {
    //No need to continue.
    exit;
}

if (self.isServer) {
    htme_chatSendServer(channel,message,to);
} else {
    //Send message to server, the server will relay the message.
    buffer_seek(self.buffer, buffer_seek_start, 0);
    buffer_write(self.buffer, buffer_s8,htme_packet.CHAT_API);
    buffer_write(self.buffer, buffer_string,channel);
    buffer_write(self.buffer, buffer_string,to);
    buffer_write(self.buffer, buffer_string,message);
    if (to == "")
        htme_debugger("htme_chatSend",htme_debug.CHATDEBUG,"CHAT API ["+channel+"] - Sending message "+message+" to all.");
    else
        htme_debugger("htme_chatSend",htme_debug.CHATDEBUG,"CHAT API ["+channel+"] - Sending message "+message+" to "+to+".");
    htme_sendNewSignedPacket(self.buffer,noone);
}
