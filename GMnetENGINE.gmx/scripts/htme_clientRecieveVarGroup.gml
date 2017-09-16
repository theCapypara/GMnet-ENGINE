///htme_clientRecieveVarGroup(instancehash,playerhash,object_id,instance,tolerance,datatype);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Adds recieved data to the instance
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      <undocumented>
**
**  Returns:
**      <Nothing>
**
*/

var instancehash = argument0;
var playerhash = argument1;
var object_id = argument2;
var instance = argument3;
var tolerance = argument4;
var datatype = argument5;

var in_ip = ds_map_find_value(async_load, "ip");
var in_buff = ds_map_find_value(async_load, "buffer");
var in_id = ds_map_find_value(async_load, "id");
var in_port = ds_map_find_value(async_load, "port");

if (playerhash == self.playerhash) {
   htme_debugger("htme_clientRecieveVarGroup",htme_debug.WARNING,"Recieved own instance!! Skipping! Fix!");
   exit;
}

var new_val;

/* Check datatype */
switch (datatype) {
    //Check special datatypes
    case mp_buffer_type.BUILTINPOSITION:  
        if (buffer_read(in_buff,buffer_bool)) {
            new_val=buffer_read(in_buff,buffer_f32);
           (instance).x = htme_RecieveVar((instance).x,new_val,tolerance,buffer_f32);}
        if (buffer_read(in_buff,buffer_bool)) {
            new_val=buffer_read(in_buff,buffer_f32);
           (instance).y = htme_RecieveVar((instance).y,new_val,tolerance,buffer_f32);}
    break;
    case mp_buffer_type.BUILTINBASIC:  
        if (buffer_read(in_buff,buffer_bool)) {
            new_val=buffer_read(in_buff,buffer_u8);
           (instance).image_alpha = htme_RecieveVar((instance).image_alpha,new_val,tolerance,buffer_u8);}
        if (buffer_read(in_buff,buffer_bool)) {
            new_val=buffer_read(in_buff,buffer_u32);
           (instance).image_blend = htme_RecieveVar((instance).image_blend,new_val,tolerance,buffer_u32);}
        if (buffer_read(in_buff,buffer_bool)) { 
            new_val=buffer_read(in_buff,buffer_u16);
           (instance).image_index = htme_RecieveVar((instance).image_index,new_val,tolerance,buffer_u16);}
        if (buffer_read(in_buff,buffer_bool)) {
            new_val=buffer_read(in_buff,buffer_f32);
           (instance).image_speed = htme_RecieveVar((instance).image_speed,new_val,tolerance,buffer_f32);}
        if (buffer_read(in_buff,buffer_bool)) {
            new_val=buffer_read(in_buff,buffer_f32);
           (instance).image_xscale = htme_RecieveVar((instance).image_xscale,new_val,tolerance,buffer_f32);}
        if (buffer_read(in_buff,buffer_bool)) {
            new_val=buffer_read(in_buff,buffer_f32);
           (instance).image_yscale = htme_RecieveVar((instance).image_yscale,new_val,tolerance,buffer_f32);}
        if (buffer_read(in_buff,buffer_bool)) {
            new_val=buffer_read(in_buff,buffer_f32);
           (instance).image_angle = htme_RecieveVar((instance).image_angle,new_val,tolerance,buffer_f32);}
        if (buffer_read(in_buff,buffer_bool)) {
            new_val=buffer_read(in_buff,buffer_bool);
           (instance).visible = htme_RecieveVar((instance).visible,new_val,tolerance,buffer_bool);}
    break;
    case mp_buffer_type.BUILTINPHYSICS:
        if (buffer_read(in_buff,buffer_bool)) {
            new_val=buffer_read(in_buff,buffer_f32);
           (instance).direction = htme_RecieveVar((instance).direction,new_val,tolerance,buffer_f32);}
        if (buffer_read(in_buff,buffer_bool)) {
            new_val=buffer_read(in_buff,buffer_f32);
           (instance).gravity = htme_RecieveVar((instance).gravity,new_val,tolerance,buffer_f32);}
        if (buffer_read(in_buff,buffer_bool)) {
            new_val=buffer_read(in_buff,buffer_u16);
           (instance).gravity_direction = htme_RecieveVar((instance).gravity_direction,new_val,tolerance,buffer_u16);}
        if (buffer_read(in_buff,buffer_bool)) {
            new_val=buffer_read(in_buff,buffer_f32);
           (instance).friction = htme_RecieveVar((instance).friction,new_val,tolerance,buffer_f32);}
        if (buffer_read(in_buff,buffer_bool)) {
            new_val=buffer_read(in_buff,buffer_f32);
           (instance).hspeed = htme_RecieveVar((instance).hspeed,new_val,tolerance,buffer_f32);}
        if (buffer_read(in_buff,buffer_bool)) {
            new_val=buffer_read(in_buff,buffer_f32);
           (instance).vspeed = htme_RecieveVar((instance).vspeed,new_val,tolerance,buffer_f32);}
    break;
    default:
        //Simple datatype
        var length = buffer_read(in_buff,buffer_u8);
        for (var l=0;l<length;l++) {
            // we must check if we got more in buffer
            // we may not get all variables if some is SMART
            // so the length can be wrong
            if (buffer_tell(in_buff)<buffer_get_size(in_buff))
            {
                var vname = buffer_read(in_buff,buffer_string);
                var vval = buffer_read(in_buff,datatype);
                //Check tolerance
                var checkedval = htme_RecieveVar(ds_map_find_value((instance).htme_mp_vars,vname),vval,tolerance,datatype);
                ds_map_replace((instance).htme_mp_vars,vname,checkedval);
            }
        }
    break;
}