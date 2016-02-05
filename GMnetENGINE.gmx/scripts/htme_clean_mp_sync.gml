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

if ds_exists(self.htme_mp_vars_recv,ds_type_map) ds_map_destroy(self.htme_mp_vars_recv);
self.htme_mp_vars_recv=-1;     
if ds_exists(self.htme_mp_vars_sync,ds_type_map) ds_map_destroy(self.htme_mp_vars_sync);
self.htme_mp_vars_sync=-1;
if ds_exists(self.htme_mp_vars,ds_type_map) ds_map_destroy(self.htme_mp_vars);
self.htme_mp_vars=-1;
