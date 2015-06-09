///htme_serverRecieveVarGroup(instancehash,playerhash,object_id,inst_stayAlive,instance,tolerance,datatype,groupname,inst_room);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Adds recieved data to the instance if it exists and adds it to the
**      backup list for this instance
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
var inst_stayAlive = argument3;
var instance = argument4;
var tolerance = argument5;
var datatype = argument6;
var groupname = argument7;
var inst_room = argument8;

var in_ip = ds_map_find_value(async_load, "ip");
var in_buff = ds_map_find_value(async_load, "buffer");
var in_id = ds_map_find_value(async_load, "id");
var in_port = ds_map_find_value(async_load, "port");

/* Get cache map entry */
var backupEntry = ds_map_find_value(self.serverBackup,instancehash);
if (is_undefined(backupEntry)) {
   //Create backup entry
   var backupEntry = ds_map_create();
   backupEntry[? "groups"] = ds_map_create();
   ds_map_copy(backupEntry[? "groups"],(instance).htme_mp_groups);
   backupEntry[? "object"] = object_id;
   backupEntry[? "player"] = playerhash;
   backupEntry[? "stayAlive"] = inst_stayAlive;
   var backupVars = ds_map_create();
   backupEntry[? "backupVars"] = backupVars;
   backupEntry[? "syncVars"] = ds_map_create();
   ds_map_add(self.serverBackup,instancehash,backupEntry);
}

/* Check datatype */
switch (datatype) {
    //Check special datatypes
    case mp_buffer_type.BUILTINPOSITION:  
        //Okay, this is a bit more complicated than with the client, because
        //we actually need to cache!
        var backupVars = backupEntry[? "backupVars"];
        if (buffer_read(in_buff,buffer_bool)) {
           var tmp_i_x = htme_RecieveVar(backupEntry[? "x"],buffer_read(in_buff,buffer_f32),tolerance,buffer_f32);
           backupVars[? "x"] = tmp_i_x;
           with instance {x = tmp_i_x;}
        }
        if (buffer_read(in_buff,buffer_bool)) {
           var tmp_i_y = htme_RecieveVar(backupEntry[? "y"],buffer_read(in_buff,buffer_f32),tolerance,buffer_f32);
           backupVars[? "y"] = tmp_i_y;
           with instance {y = tmp_i_y;}
        }
    break;
    case mp_buffer_type.BUILTINBASIC:  
        var backupVars = backupEntry[? "backupVars"];
        if (buffer_read(in_buff,buffer_bool)) {
            var tmp_i_image_alpha = htme_RecieveVar(backupEntry[? "image_alpha"],buffer_read(in_buff,buffer_u8),tolerance,buffer_u8);
            backupVars[? "image_alpha"] = tmp_i_image_alpha;
            with instance { image_alpha = tmp_i_image_alpha;}
        }
        if (buffer_read(in_buff,buffer_bool)) {
            var tmp_i_image_blend = htme_RecieveVar(backupEntry[? "image_blend"],buffer_read(in_buff,buffer_u32),tolerance,buffer_u32);
            backupVars[? "image_blend"] = tmp_i_image_blend;
            with instance { image_blend = tmp_i_image_blend;}
        }
        if (buffer_read(in_buff,buffer_bool)) {
            var tmp_i_image_index = htme_RecieveVar(backupEntry[? "image_index"],buffer_read(in_buff,buffer_u16),tolerance,buffer_u16);
            backupVars[? "image_index"] = tmp_i_image_index;
            with instance { image_index = tmp_i_image_index;}
        }
        if (buffer_read(in_buff,buffer_bool)) {
            var tmp_i_image_speed = htme_RecieveVar(backupEntry[? "image_speed"],buffer_read(in_buff,buffer_f32),tolerance,buffer_f32);
            backupVars[? "image_speed"] = tmp_i_image_speed;
            with instance { image_speed = tmp_i_image_speed;}
        }
        if (buffer_read(in_buff,buffer_bool)) {
            var tmp_i_image_xscale = htme_RecieveVar(backupEntry[? "image_xscale"],buffer_read(in_buff,buffer_f32),tolerance,buffer_f32);
            backupVars[? "image_xscale"] = tmp_i_image_xscale;
            with instance { image_xscale = tmp_i_image_xscale;}
        }
        if (buffer_read(in_buff,buffer_bool)) {
            var tmp_i_image_yscale = htme_RecieveVar(backupEntry[? "image_yscale"],buffer_read(in_buff,buffer_f32),tolerance,buffer_f32);
            backupVars[? "image_yscale"] = tmp_i_image_yscale;
            with instance { image_yscale = tmp_i_image_yscale;}
        }
        if (buffer_read(in_buff,buffer_bool)) {
            var tmp_i_visible = htme_RecieveVar(backupEntry[? "visible"],buffer_read(in_buff,buffer_bool),tolerance,buffer_bool);
            backupVars[? "visible"] = tmp_i_visible;
            with instance { visible = tmp_i_visible;}
        }
    break;
    case mp_buffer_type.BUILTINPHYSICS:
        var backupVars = backupEntry[? "backupVars"];
        if (buffer_read(in_buff,buffer_bool)) {
            var tmp_i_direction = htme_RecieveVar(backupEntry[? "direction"],buffer_read(in_buff,buffer_f32),tolerance,buffer_f32);
            backupVars[? "direction"] = tmp_i_direction;
            with instance {direction = tmp_i_direction;}
        }
        if (buffer_read(in_buff,buffer_bool)) {
            var tmp_i_gravity = htme_RecieveVar(backupEntry[? "gravity"],buffer_read(in_buff,buffer_f32),tolerance,buffer_f32);
            backupVars[? "gravity"] = tmp_i_gravity;
            with instance {gravity = tmp_i_gravity;}
        }
        if (buffer_read(in_buff,buffer_bool)) {
            var tmp_i_gravity_direction = htme_RecieveVar(backupEntry[? "gravity_direction"],buffer_read(in_buff,buffer_u16),tolerance,buffer_u16);
            backupVars[? "gravity_direction"] = tmp_i_gravity_direction;
            with instance {gravity_direction = tmp_i_gravity_direction;}
        }
        if (buffer_read(in_buff,buffer_bool)) {
            var tmp_i_friction = htme_RecieveVar(backupEntry[? "friction"],buffer_read(in_buff,buffer_f32),tolerance,buffer_f32);
            backupVars[? "friction"] = tmp_i_friction;
            with instance {friction = tmp_i_friction;}
        }
        if (buffer_read(in_buff,buffer_bool)) {
            var tmp_i_hspeed = htme_RecieveVar(backupEntry[? "hspeed"],buffer_read(in_buff,buffer_f32),tolerance,buffer_f32);
            backupVars[? "hspeed"] = tmp_i_hspeed;
            with instance {hspeed = tmp_i_hspeed;}
        }
        if (buffer_read(in_buff,buffer_bool)) {
            var tmp_i_vspeed = htme_RecieveVar(backupEntry[? "vspeed"],buffer_read(in_buff,buffer_f32),tolerance,buffer_f32);
            backupVars[? "vspeed"] = tmp_i_vspeed;
            with instance {vspeed = tmp_i_vspeed;}
        }
    break;
    default:
        //Simple datatype
        var backupVars = backupEntry[? "backupVars"];
        var length = buffer_read(in_buff,buffer_u8);
        for (var l=0;l<length;l++) {
            var vname = buffer_read(in_buff,buffer_string);
            var vval = buffer_read(in_buff,datatype);
            //Check tolerance
            var checkedval = htme_RecieveVar(ds_map_find_value(backupVars,vname),vval,tolerance,datatype);
            with (instance) { ds_map_replace(self.htme_mp_vars,vname,checkedval);}
            //Also add to backup
            ds_map_replace(backupVars,vname,checkedval);
        }
    break;
}

//EXPERIMENTAL: Relay instantly, instead of looping over it.
//Relay to all clients

//Don't use sync functions, relay buffer instantly
buffer_seek(in_buff, buffer_seek_start, 0);
//Is this signed?
if (buffer_read(in_buff, buffer_s8 ) == htme_packet.SIGNEDPACKET_NEW) {
    //Strip id
    buffer_read(in_buff, buffer_u32);
    var bt = buffer_tell(in_buff);
    buffer_seek(in_buff, buffer_seek_end, 0);
    buffer_seek(self.buffer, buffer_seek_start, 0);
    buffer_copy(in_buff,bt,buffer_tell(in_buff),self.buffer,0);
    buffer_seek(self.buffer, buffer_seek_end, 0);
    if (!htme_isStayAlive(instancehash)) {
        htme_sendNewSignedPacket(self.buffer,all,in_ip+":"+string(in_port),inst_room);
    } else {
        htme_sendNewSignedPacket(self.buffer,all,in_ip+":"+string(in_port));
    }
} else {
    //Send normally
    buffer_seek(in_buff, buffer_seek_end, 0);
    if (!htme_isStayAlive(instancehash)) {
       htme_serverSendBufferToAllExcept(in_buff,in_ip+":"+string(in_port),inst_room);
    } else {
      htme_serverSendBufferToAllExcept(in_buff,in_ip+":"+string(in_port));
    }
}

//Delete the instance if it was only created in htme_recieveVarGroup because there was no backup
if (self.tmp_instanceForceCreated) {
   self.tmp_instanceForceCreated = false;
   htme_debugger("htme_serverRecieveVarGroup",htme_debug.WARNING,"Deleted a temporary instance.");
   with instance {instance_destroy();}
}
