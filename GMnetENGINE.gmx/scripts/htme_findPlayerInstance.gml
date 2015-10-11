///htme_findPlayerInstance(object,player);

/*
**  Description:
**      Returns the first instance (id) of an object
**      that belongs to the player given via
**      argument. If none is found, this returns -1.
**  
**  Usage:
**      <see above>
**
**  Arguments:
**      object     object id   the object to search for
**      player     string      hash of the player
**
**  Returns:
**      instance id or -1
**
*/

var object = argument0;
var player = argument1;

var key= ds_map_find_first(global.htme_object.globalInstances);
//This will loop through all global instances
for(var i=0; i<ds_map_size(global.htme_object.globalInstances); i+=1) {
    var inst_id = ds_map_find_value(global.htme_object.globalInstances,key);
    if (instance_exists(inst_id)) {
       if (inst_id.object_index == object && (inst_id).htme_mp_player == player) {
          return inst_id; 
       }
    }
    key = ds_map_find_next(global.htme_object.globalInstances, key);
}
return -1;
