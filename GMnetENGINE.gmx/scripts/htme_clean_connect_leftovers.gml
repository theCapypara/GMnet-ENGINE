/// htme_clean_connect_leftovers();
/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Clean must have connect maps. When disconnect we must have these maps
**      But if we destroy/re-init the obj_htme we must destroy these maps
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
if self.buffer>-1 buffer_delete(self.buffer);
self.buffer=-1;
if ds_exists(self.localInstances,ds_type_map) ds_map_destroy(self.localInstances);
self.localInstances=-1;
if ds_exists(self.globalInstances,ds_type_map) ds_map_destroy(self.globalInstances);
self.globalInstances=-1;
if ds_exists(self.sPcountOUT,ds_type_map) ds_map_destroy(self.sPcountOUT);
self.sPcountOUT=-1;
if ds_exists(self.sPcountIN,ds_type_map) ds_map_destroy(self.sPcountIN);
self.sPcountIN=-1;
