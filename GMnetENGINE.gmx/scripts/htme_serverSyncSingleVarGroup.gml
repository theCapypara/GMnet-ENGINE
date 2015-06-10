///htme_serverSyncSingleVarGroup(group,buffer);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Stores the data of the instance in the buffer. if the instance does
**      not exist, data from the backup list is taken
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      group     ds_map            vargroup to sync
**      buffer    real              id of sending buffer
**
**
**  Returns:
**      real - number of synced variables - 0 (false) if none!
**
*/

var group = argument0;
var buffer = argument1;
var num = 0;

/**RETRIEVE INFORMATION**/
var inst_hash = group[? "instancehash"];
var inst = group[? "instance"];
var backupEntry = ds_map_find_value(self.serverBackup,inst_hash);
var inst_groups = backupEntry[? "groups"];
var inst_object = backupEntry[? "object"];
var inst_player = backupEntry[? "player"];      
var inst_stayAlive = backupEntry[? "stayAlive"];

var backupVars = backupEntry[? "backupVars"];
var prevSyncMap = backupEntry[? "syncVars"];
switch (group[? "datatype"]) {
    //Check special datatypes
    case mp_buffer_type.BUILTINPOSITION:  
        num += htme_syncVar(buffer,group,buffer_f32,backupVars[? "x"],"x",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_f32,backupVars[? "y"],"y",prevSyncMap);
    break;
    case mp_buffer_type.BUILTINBASIC:  
        num += htme_syncVar(buffer,group,buffer_u8,backupVars[? "image_alpha"],"image_alpha",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_u32,backupVars[? "image_blend"],"image_blend",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_u16,backupVars[? "image_index"],"image_index",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_f32,backupVars[? "image_speed"],"image_speed",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_f32,backupVars[? "image_xscale"],"image_xscale",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_f32,backupVars[? "image_yscale"],"image_yscale",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_bool,backupVars[? "visible"],"visible",prevSyncMap);
    break;
    case mp_buffer_type.BUILTINPHYSICS:
        num += htme_syncVar(buffer,group,buffer_f32,backupVars[? "direction"],"direction",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_f32,backupVars[? "gravity"],"gravity",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_u16,backupVars[? "gravity_direction"],"gravity_direction",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_f32,backupVars[? "friction"],"friction",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_f32,backupVars[? "hspeed"],"hspeed",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_f32,backupVars[? "vspeed"],"vspeed",prevSyncMap);
    break;
    default:
        //Simple datatype
        buffer_write(buffer, buffer_u8, ds_list_size(group[? "variables"]));
        for (var l=0;l<ds_list_size(group[? "variables"]);l++) {
            var vname = ds_list_find_value(group[? "variables"],l);
            var vval = ds_map_find_value(backupVars,vname);
            if (is_undefined(vval)) {
               //Undefined! We haven't even recieved this yet, how on earth would be sync it?!
               return false;
            }
            num += htme_syncVar(buffer,group,group[? "datatype"],vval,vname,prevSyncMap,true);
        }
    break;
}
return num;
