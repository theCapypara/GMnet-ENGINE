///htme_chatGetSender(chat_queue_entry)

/*
**  Description:
**      Get the sender of a CHAT API message. See mp_chatGetQueue for details.
**
**  Usage:
**      <See above>
**
**  Arguments:
**      chat_queue_entry     string      An entry of the queue returned by mp_chatGetQueue
**
**  Returns:
**      Playerhash of the player that sent this message
**
*/

return htme_string_explode(argument0,chr(31),0);
