///htme_clientIsConnected()

/*
**  Description:
**      Use this function to determine if the client is connected to a server.
**      * This only works as expected if a client was already started
**  
**  Usage:
**      <see above>
**
**  Arguments:
**      <none>
**
**  Returns:
**      true, if connected, false if not
**
*/

// Check if obj_htme exists (udphp_stopClient may have destroyed it when connection falied)
if instance_exists(global.htme_object)
{
    with (global.htme_object) {
        //Connection isn't finished if we don't have a playerhash.
        if (self.playerhash == "") return false;
        return self.isConnected;
    }
}
else
{
    return false;
}