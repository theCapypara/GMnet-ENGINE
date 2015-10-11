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

with (global.htme_object) {
    return self.clientStopped;
}
