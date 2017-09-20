///htme_isLostConnection()

/*
**  Description:
**      This checks if a client or Server is Lost Connection
**      This is very handy when you handle client exit if the server
**      kicked you. Just check if this returns true then go to another room.
**  
**  Usage:
**      <see above>
**
**  Arguments:
**      <none>
**
**  Returns:
**      true, if lost, false if not.
**
*/
if instance_exists(global.htme_object) {
    if (!htme_isStarted()) {
        // Clean everything
        if global.htme_object.clientStopped=false {
            with global.htme_object htme_clientDisconnect();
        }
        return true;
    }
} else {
    return true;
}
return false;
