///htme_isSefver()

/*
**  Description:
**      This checks if a client or server is running
**      NOTE:
**      This will always return true for non local instances, this can't be
**      used to identify if a remote instance belongs to the server!
**      The main purpose of this script is to create instance that are only
**      controlled by the server and don't get created locally at the client side.
**  
**  Usage:
**      <see above>
**
**  Arguments:
**      <none>
**
**  Returns:
**      true, if server is running, false if client.
**      always true if instance is not local.
**
*/

with (global.htme_object) {
    if (self.tmp_creatingNetworkInstance) return true;
    return self.isServer;
}
