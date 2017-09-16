///htme_debugOverlayEnabled();

/*
**  Description:
**      Check if the debug overlay is enabled. Can be enabled or disabled
**      in htme_init.
**  
**  Usage:
**      <see above>
**
**  Arguments:
**      <none>
**
**  Returns:
**      boolean
**
*/

// Check if obj_htme exists (udphp_stopClient may have destroyed it when connection falied)
if instance_exists(global.htme_object)
{
    return global.htme_object.debugoverlay;
}
else
{
    return false;
}