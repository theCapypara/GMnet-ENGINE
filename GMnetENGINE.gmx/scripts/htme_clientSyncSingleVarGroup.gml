///htme_clientSyncSingleVarGroup(group,buffer);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Stores the data of the instance in the buffer
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      group     ds_map            vargroup to sync
**      buffer    real              id of sending buffer
**
**  Returns:
**      real - number of synced variables - 0 (false) if none!
**
*/

var group = argument0;
var buffer = argument1;

/**RETRIEVE INFORMATION**/
var inst_hash = group[? "instancehash"];
var inst = group[? "instance"];
var inst_groups = (inst).htme_mp_groups;
var inst_object = (inst).htme_mp_object;
var inst_player = (inst).htme_mp_player;   
var inst_stayAlive =  (inst).htme_mp_stayAlive;

var num = 0;
var prevSyncMap = (inst).htme_mp_vars_sync;

switch (group[? "datatype"]) {
    //Check special datatypes
    case mp_buffer_type.BUILTINPOSITION:  
        num += htme_syncVar(buffer,group,buffer_f32,(inst).x,"x",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_f32,(inst).y,"y",prevSyncMap);
    break;
    case mp_buffer_type.BUILTINBASIC:  
        num += htme_syncVar(buffer,group,buffer_u8,(inst).image_alpha,"image_alpha",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_u32,(inst).image_blend,"image_blend",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_u16,(inst).image_index,"image_index",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_f32,(inst).image_speed,"image_speed",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_f32,(inst).image_xscale,"image_xscale",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_f32,(inst).image_yscale,"image_yscale",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_bool,(inst).visible,"visible",prevSyncMap);
    break;
    case mp_buffer_type.BUILTINPHYSICS:
        num += htme_syncVar(buffer,group,buffer_f32,(inst).direction,"direction",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_f32,(inst).gravity,"gravity",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_u16,(inst).gravity_direction,"gravity_direction",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_f32,(inst).friction,"friction",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_f32,(inst).hspeed,"hspeed",prevSyncMap);
        num += htme_syncVar(buffer,group,buffer_f32,(inst).vspeed,"vspeed",prevSyncMap);
    break;
    default:
        //Simple datatype
        buffer_write(buffer, buffer_u8, ds_list_size(group[? "variables"]));
        for (var l=0;l<ds_list_size(group[? "variables"]);l++) {
            var vname = ds_list_find_value(group[? "variables"],l);
            var vval = ds_map_find_value((inst).htme_mp_vars,vname);
            if (is_undefined(vval)) {
               //Undefined! We haven't even recieved this yet, how on earth would be sync it?!
               return false;
            }
            num += htme_syncVar(buffer,group,group[? "datatype"],vval,vname,prevSyncMap,true);
        }
    break;
}
return num;
