//htme_chatAddToQueue(channel,message,to)

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Add a recieved message to the right queue.
**      
**      NEVER CALL THIS MANUALLY!
**
**  Usage:
**      <See above>
**
**  Arguments:
**      channel         string          The channel to send on
**      message         string          The message to send
**      to              string          Hash of the player that the message was for.
**                                      This is either "" for all or our playerhash.
**                                      Otherwise something went wrong.
**
**  Returns:
**      <none>
**
*/

var channel = argument0;
var message = argument1;
var to = argument2; //Currently not used.

htme_debugger("htme_chatSend",htme_debug.CHATDEBUG,"CHAT API ["+channel+"] - Recieved message "+message);

//This will add the channel if it doesn't exist yet and then return it.
var queue = htme_chatAddChannel(channel);

ds_queue_enqueue(queue, message);
