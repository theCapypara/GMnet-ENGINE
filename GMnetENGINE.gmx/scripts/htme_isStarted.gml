///htme_htme_isStarted()

/*
**  Description:
**      This checks if a client or Server is running
**  
**  Usage:
**      <see above>
**
**  Arguments:
**      <none>
**
**  Returns:
**      true, if running, false if not.
**
*/

with (global.htme_object) {
    return self.started;
}
