///htme_clientSyncSingleVarGroup(group,target,instance,inst_hash,inst_object,inst_player,cmd_list,dbg_contents);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Stores the data of the instance in the cmd_list
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      <undocumented>
**
**  Returns:
**      real - number of synced variables - 0 (false) if none!
**
*/

var group = argument0;
var target = argument1;
var instance = argument2;
var inst_hash = argument3;
var inst_object = argument4;
var inst_player = argument5;
var cmd_list = argument6;
var dbg_contents = argument7;
var num = 0;
var prevSyncMap = (instance).htme_mp_vars_sync;

switch (group[? "datatype"]) {
    //Check special datatypes
    case mp_buffer_type.BUILTINPOSITION:  
        num += htme_syncVar(cmd_list,group,buffer_f32,(instance).x,"x",prevSyncMap);
        num += htme_syncVar(cmd_list,group,buffer_f32,(instance).y,"y",prevSyncMap);
    break;
    case mp_buffer_type.BUILTINBASIC:  
        num += htme_syncVar(cmd_list,group,buffer_u8,(instance).image_alpha,"image_alpha",prevSyncMap);
        num += htme_syncVar(cmd_list,group,buffer_u32,(instance).image_blend,"image_blend",prevSyncMap);
        num += htme_syncVar(cmd_list,group,buffer_u16,(instance).image_index,"image_index",prevSyncMap);
        num += htme_syncVar(cmd_list,group,buffer_f32,(instance).image_speed,"image_speed",prevSyncMap);
        num += htme_syncVar(cmd_list,group,buffer_f32,(instance).image_xscale,"image_xscale",prevSyncMap);
        num += htme_syncVar(cmd_list,group,buffer_f32,(instance).image_yscale,"image_yscale",prevSyncMap);
        num += htme_syncVar(cmd_list,group,buffer_bool,(instance).visible,"visible",prevSyncMap);
    break;
    case mp_buffer_type.BUILTINPHYSICS:
        num += htme_syncVar(cmd_list,group,buffer_f32,(instance).direction,"direction",prevSyncMap);
        num += htme_syncVar(cmd_list,group,buffer_f32,(instance).gravity,"gravity",prevSyncMap);
        num += htme_syncVar(cmd_list,group,buffer_u16,(instance).gravity_direction,"gravity_direction",prevSyncMap);
        num += htme_syncVar(cmd_list,group,buffer_f32,(instance).friction,"friction",prevSyncMap);
        num += htme_syncVar(cmd_list,group,buffer_f32,(instance).hspeed,"hspeed",prevSyncMap);
        num += htme_syncVar(cmd_list,group,buffer_f32,(instance).vspeed,"vspeed",prevSyncMap);
    break;
    default:
        //Simple datatype
        ds_list_add(cmd_list, buffer_u8, ds_list_size(group[? "variables"]));
        for (var l=0;l<ds_list_size(group[? "variables"]);l++) {
            var vname = ds_list_find_value(group[? "variables"],l);
            var vval = ds_map_find_value((instance).htme_mp_vars,vname);
            if (is_undefined(vval)) {
               //Undefined! We haven't even recieved this yet, how on earth would be sync it?!
               return false;
            }
            num += htme_syncVar(cmd_list,group,group[? "datatype"],vval,vname,prevSyncMap,true);
            dbg_contents += vname+": "+string(vval)+",";
        }
    break;
}
return num;