///htme_chatGetMessage(chat_queue_entry)

/*
**  Description:
**      Get the message of a CHAT API message. See mp_chatGetQueue for details.
**
**  Usage:
**      <See above>
**
**  Arguments:
**      chat_queue_entry     string      An entry of the queue returned by mp_chatGetQueue
**
**  Returns:
**      Message that was sent
**
*/

return htme_string_explode(argument0,chr(31),1);
