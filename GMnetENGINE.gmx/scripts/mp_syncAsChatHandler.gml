///mp_syncAsChatHandler(channel)

/*
**  Description:
**      Add this object as a handler for traffic via the CHAT API.
**      This object can send and recieve traffic on the specified channel using 
**      mp_chatGetQueue and mp_chatSend.
**      This is independent from mp_sync and it's mp commands.
**
**  Usage:
**      <See above>
**
**  Arguments:
**      channel     string      The name of the channel to assign to this object
**
**  Returns:
**      <none>
**
*/

self.htme_mp_chatChannel = argument0;

with global.htme_object {
    htme_chatAddChannel(argument0);
}
