///mp_chatSend(message,[to])

/*
**  Description:
**      Object has to be set up with mp_syncAsChatHandler first, otherwise an error will occur.
**
**      Send message via the CHAT API over this chanel.
**      The message has to be a string. You can also experiment with json to send more
**      complicated data.
**      
**      This message will by default be sent to all clients and the server [also the local 
**      game!] and can be retrieved via mp_chatGetQueue().
**
**      Use the additional 'to' argument to only send this string to one player
**
**      Make sure the playerhash for the 'to' argument is valid. It will not be checked for
**      a better performance.
**
**  Usage:
**      <See above>
**
**  Arguments:
**      message         string          The message to send
**      [to]            string          (optional; Will send to all by default)
**                                      hash of the player that the message should be sent
**                                      to.
**
**  Returns:
**      <none>
**
*/

var channel = self.htme_mp_chatChannel;

with global.htme_object {
    if (argument_count > 1) {
        htme_chatSend(channel, argument[0], argument[1]);
    } else {
        htme_chatSend(channel, argument[0]);
    }
}
