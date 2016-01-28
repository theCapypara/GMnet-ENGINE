/// htme_clean_mp_sync();
/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Clean private ds maps from synced instances
**
**  Usage:
**      <See above>
**
**  Arguments:
**      <none>
**
**  Returns:
**      <nothing>
**
*/

ds_map_destroy(self.htme_mp_vars_recv);     
ds_map_destroy(self.htme_mp_vars_sync);
ds_map_destroy(self.htme_mp_vars);
