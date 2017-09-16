///mp_stayAlive();

/*
**  Description:
**      Configure this instance to be in stayAlive mode and be room indipendent.
**      Instance NEEDS to be persistent!
**      See manual for more information
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      <nothing>
**
**  Returns:
**      <none>
**
*/

self.htme_mp_stayAlive = true;
if (persistent == false) {
        htme_debugger("mp_stayAlive",htme_debug.WARNING,"Instance is in stay alive mode but not currently persistent!");
        persistent = true;
    }