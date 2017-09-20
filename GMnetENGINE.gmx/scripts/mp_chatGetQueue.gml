///mp_chatGetQueue()

/*
**  Description:
**      Object has to be set up with mp_syncAsChatHandler first, otherwise an error will occur.
**
**      Get a ds_queue containing all not processed string that recieved via this channel.
**      All entries in this queue can be decoded using these commands:
**      * htme_chatGetSender() - To get the playerhash of the player that sent this message
**      * htme_chatGetMessage() - To get the chat message.
**
**  Usage:
**      <See above>
**
**  Arguments:
**      <none>
**
**  Returns:
**      A ds_queue, it's entries can be decoded using the functions above.
**
*/

var channel = self.htme_mp_chatChannel;
var all_queues = global.htme_object.chatQueues;
return ds_map_find_value(all_queues, channel);
