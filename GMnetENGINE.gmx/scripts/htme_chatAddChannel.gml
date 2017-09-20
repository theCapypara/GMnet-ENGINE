//htme_chatAddChannel(channel)

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Add a channel and a queue, if not existing, to the CHAT API.
**      Returns the queue.
**
**  Usage:
**      <See above>
**
**  Arguments:
**      channel         string          The channel
**
**  Returns:
**      The queue
**
*/

var channel = argument0;

var queue = ds_map_find_value(self.chatQueues, channel);

if (is_undefined(queue)) {
    htme_debugger("htme_chatAddChannel",htme_debug.CHATDEBUG,"CHAT API ["+channel+"] - Added channel");
    queue = ds_queue_create();
    ds_map_replace(self.chatQueues, channel, queue);
}

return queue;
