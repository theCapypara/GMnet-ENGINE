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

ds_map_destroy(self.localInstances);
ds_map_destroy(self.globalInstances);
ds_map_destroy(self.sPcountOUT);
ds_map_destroy(self.sPcountIN);