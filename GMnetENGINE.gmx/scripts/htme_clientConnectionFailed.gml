///htme_clientConnectionFailed()

/*
**  Description:
**      Use this function to determine if the connection failed after starting a client.
**      The usage is very specific:
**      * This only works as expected if a client was already started
**  
**  Usage:
**      <see above>
**
**  Arguments:
**      <none>
**
**  Returns:
**      true, if connection failed or client has otherwise died
**      false if connection is still processing or finished.
**
*/

// Check if obj_htme exists (udphp_stopClient may have destroyed it when connection falied)
if instance_exists(global.htme_object)
{
    with (global.htme_object) {
        return self.clientStopped;
    }
}
else
{
    return true;
}