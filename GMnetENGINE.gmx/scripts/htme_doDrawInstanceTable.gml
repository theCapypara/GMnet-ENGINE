///htme_debugoverlayDrawInstanceTable(title,type,filter,drawInRoom);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Draw debug information of visible instances
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      title      string         The title to display on the overlay
**      type       real           What kind of instances should be shown?
**                                0 - all
**                                1 - only visible
**                                2 - only invisible
**                                3 - only cached
**      filter     real/string    REAL:
**                                   all - Show all instances
**                                String:
**                                   Only show the messages of the player
**                                   with this player hash.
**      drawInRoom boolean        Add a debug string to every visible instance
**                                in the room
**
**  Returns:
**      <Nothing>
**
*/

var title = argument0;
var type = argument1;
var filter = argument2;
var drawInRoom = argument3;

draw_set_halign(fa_left);
//HEADER

if (self.dbgcntx2 != "") {
   //DETAILS
    var headstr = "INSTANCE DETAILS OF "+self.dbgcntx2+"#========#Scroll up: PAGE UP - Scroll down: PAGE DOWN - Page "+string(self.dbgpage+1)+"#========#";
    var base = self.dbg_top+20+string_height(headstr)+10;
    var offs = base-((self.dbg_bottom-base)*(self.dbgpage));
    var isVisible = false;
    var isExisting = false;
    var isLocal = false;
    var hash = self.dbgcntx2;
    var instance = ds_map_find_value(self.globalInstances,hash);
    if (instance_exists(instance)) {
        var savedvars = (instance).htme_mp_vars;
        var object = object_get_name((instance).htme_mp_object);
        var player = (instance).htme_mp_player;
        var inst_groups = (instance).htme_mp_groups;   
        var persis = (instance).persistent; 
        var stayAlive = (instance).htme_mp_stayAlive;
        with instance {isLocal = htme_isLocal();}
        if ((instance).visible && (instance).sprite_index != -1) {
           var insttext = hash + " #"
               + "x;y: " + string((instance).x)+";"+string((instance).y);
           isVisible = true;
        }
        isExisting = true;
    } else if (self.isServer) {
        var backupEntry = ds_map_find_value(self.serverBackup,hash);
        if (is_undefined(backupEntry))  {self.dbgcntx2 = "";exit;}
            instance = "n/a";
        var persis = "n/a";
        var savedvars = backupEntry[? "backupVars"];
        var object = object_get_name(backupEntry[? "object"]);
        var player = backupEntry[? "player"];
        var inst_groups = backupEntry[? "groups"];       
        var stayAlive = backupEntry[? "stayAlive"];
    } else  {self.dbgcntx2 = "";exit;}
    if (is_undefined(player)) {self.dbgcntx2 = "";exit;}
    
    var str =   "Hash:        "+hash+"#";
    str = str + "IsVisible:   "+string(isVisible)+"#";
    str = str + "isNotCached: "+string(isExisting)+"#";
    str = str + "isLocal:     "+string(isLocal)+"#";
    str = str + "Persistent:  "+string(persis)+"#";
    str = str + "stayAllive:  "+string(stayAlive)+"#";
    str = str + "Instance ID: "+string(instance)+"#";
    str = str + "Object:      "+object+"#";
    str = str + "Player:      Player "+string(htme_getPlayerNumber(player))+" - "+player+"#";
    
    // SAVEDVARS
        str = str + "#========#SAVED VARIABLES: #========#"; 
    if (isExisting) {
        str = str + "--------#Via mp_sync_in: #--------#"; 
    }
    var inner_key= ds_map_find_first(savedvars);
    //This will loop through all saved variables of this instance
    for(var j=0; j<ds_map_size(savedvars); j+=1) {
       var ivalue = ds_map_find_value(savedvars,inner_key);
       str = str + inner_key+": "+string(ivalue)+"#";
       inner_key = ds_map_find_next(savedvars,inner_key);
    }
    if (isExisting) {
        str = str + "--------#Builtin variables: #--------#"; 
        str = str + "x: "+string((instance).x)+"#";
        str = str + "y: "+string((instance).y)+"#";
        str = str + "image_alpha: "+string((instance).image_alpha)+"#";
        str = str + "image_angle: "+string((instance).image_angle)+"#";
        str = str + "image_blend: "+string((instance).image_blend)+"#";
        str = str + "image_index: "+string((instance).image_index)+"#";
        str = str + "image_speed: "+string((instance).image_speed)+"#";
        str = str + "image_xscale: "+string((instance).image_xscale)+"#";
        str = str + "image_yscale: "+string((instance).image_yscale)+"#";
        str = str + "visible: "+string((instance).visible)+"#";
        str = str + "direction: "+string((instance).direction)+"#";
        str = str + "gravity: "+string((instance).gravity)+"#";
        str = str + "gravity_direction: "+string((instance).gravity_direction)+"#";
        str = str + "friction: "+string((instance).friction)+"#";
        str = str + "hspeed: "+string((instance).hspeed)+"#";
        str = str + "vspeed: "+string((instance).vspeed)+"#";
    }
    // /SAVEDVARS
    
    // VARGROUPS
    str = str + "#========#VARGROUPS: #========#"; 
    var inner_key= ds_map_find_first(inst_groups);
    //This will loop through all variable groups of this instance
    for(var j=0; j<ds_map_size(inst_groups); j+=1) {
       var group = ds_map_find_value(inst_groups,inner_key);
       str = str + "--------#" + group[? "name"] +":#--------#" 
       if (isLocal)
          str = str + "Syncing in " + string(group[? "__counter"]) + "#";
       var synctype = "";
       switch (group[? "type"]) {
           case mp_type.FAST:
               synctype = "FAST";
           break;
           case mp_type.IMPORTANT:
               synctype = "IMPORTANT";
           break;
           case mp_type.SMART:
               synctype = "SMART";
           break;
       }
       str = str + "SyncType " + string(synctype) + "#";
       var datatype_str;
       var var_str = "";
        switch (group[? "datatype"]) {
            case buffer_u8:
                datatype_str = "buffer_u8";
            break;
            case buffer_s8:
                datatype_str = "buffer_s8";
            break;
            case buffer_u16:
                datatype_str = "buffer_u16";
            break;
            case buffer_s16:
                datatype_str = "buffer_s16";
            break;
            case buffer_u32:
                datatype_str = "buffer_u32";
            break;
            case buffer_s32:
                datatype_str = "buffer_s32";
            break;
            case buffer_u64:
                datatype_str = "buffer_u64";
            break;
            case buffer_f16:
                datatype_str = "buffer_f16";
            break;
            case buffer_f32:
                datatype_str = "buffer_f32";
            break;
            case buffer_f64:
                datatype_str = "buffer_f64";
            break;
            case buffer_bool:
                datatype_str = "buffer_bool";
            break;
            case buffer_string:
                datatype_str = "buffer_string";
            break;
            case mp_buffer_type.BUILTINPOSITION:
                datatype_str = "(Builtin Position)";
                var_str = "x,y,";
            break;
            case mp_buffer_type.BUILTINBASIC:
                datatype_str = "(Builtin Basic)";
                var_str = "image_alpha,image_angle,image_blend,image_index,image_speed,#image_xscale,image_yscale,visible,";
            break;
            case mp_buffer_type.BUILTINPHYSICS:
                datatype_str = "(Builtin Physics)";
                var_str = "direction,gravity,gravity_direction,friction,hspeed,vspeed,";
            break;
        }
       str = str + "Datatype: "+datatype_str+"#";
       str = str + "Variables:#";
       if ( var_str == "") {
           var vars = group[? "variables"];
           for (var k=0;k<ds_list_size(vars);k++) {
               var_str = var_str + ds_list_find_value(vars,k) + ",";
           }
       }
       str = str + "  "+var_str+"#";
       inner_key = ds_map_find_next(inst_groups,inner_key);
     } 
     // /VARGROUPS
     
     
    if (isExisting && isVisible) {
        if (isLocal) draw_set_colour(self.dbgcolor_a);
        draw_text((instance).x-(instance).sprite_xoffset+(instance).sprite_width,(instance).y-(instance).sprite_yoffset+(instance).sprite_height,insttext);
        if (isLocal) draw_set_colour(self.dbgcolor);
    }
    
    draw_text(self.dbg_left+20,offs,str);
} else {
    //INSTANCE TABLE
    var headstr = title+"#========#Scroll up: PAGE UP - Scroll down: PAGE DOWN - Page "+string(self.dbgpage+1)+"#========#";
    var base = self.dbg_top+20+string_height(headstr)+10;
    var offs = base-((self.dbg_bottom-base)*(self.dbgpage));
    // DETAIL COUNTER
    var detail = 49;
    // /DT
    
    var mapToUse = self.globalInstances;
    var key= ds_map_find_first(mapToUse);
    //This will loop through all global instances
    for(var i=0; i<ds_map_size(mapToUse); i+=1) {
        var inst = ds_map_find_value(mapToUse,key);
        var isExisting = false;
        var isLocal = false;
        var isVisible = false;
        if (instance_exists(inst)) {
            var inst_groups = (inst).htme_mp_groups;
            var inst_object = (inst).htme_mp_object;
            var inst_player = (inst).htme_mp_player;
            with inst {isLocal = htme_isLocal();}
            if ((inst).visible && (inst).sprite_index != -1) {
               var insttext = key + " #"
                   + "x;y: " + string((inst).x)+";"+string((inst).y);
               isVisible = true;
            }
            isExisting = true;
        } else if (self.isServer) {
            var backupEntry = ds_map_find_value(self.serverBackup,key);
            var inst_groups = backupEntry[? "groups"];
            var inst_object = backupEntry[? "object"];
            var inst_player = backupEntry[? "player"];                
            var inst_stayAlive = backupEntry[? "stayAlive"];
        } else {key = ds_map_find_next(mapToUse, key);continue;}
        
        var instsummary = htme_do_createMicro(inst_player,inst_object,inst,key,isVisible,isExisting)+"#";
        
        //Continue if type is not met
        if (!(
          type == 0 ||
          (type == 1 && isVisible && isExisting) ||
          (type == 2 && !isVisible && isExisting) ||
          (type == 3 && !isExisting))) {
          key = ds_map_find_next(mapToUse, key);
          continue;
        }
        //Continue if filter is not met
        if (is_string(filter)) {
           if (filter != inst_player) {
              key = ds_map_find_next(mapToUse, key);
              continue;
           }
        }
          
        if (isExisting && isLocal) {
           instsummary = instsummary + "VARGROUPS: #"; 
           var inner_key= ds_map_find_first(inst_groups);
            //This will loop through all variable groups of this instance
            for(var j=0; j<ds_map_size(inst_groups); j+=1) {
                var group = ds_map_find_value(inst_groups,inner_key);
                instsummary = instsummary + "  " +
                   group[? "name"] + ": Syncing in " + string(group[? "__counter"]) + "#";
                inner_key = ds_map_find_next(inst_groups,inner_key);
            }  
        }
        
        //Draw text to instance
        if (isExisting && isVisible && drawInRoom) {
            if (isLocal) draw_set_colour(self.dbgcolor_a);
            draw_text((inst).x-(inst).sprite_xoffset+(inst).sprite_width,(inst).y-(inst).sprite_yoffset+(inst).sprite_height,insttext);
            if (isLocal) draw_set_colour(self.dbgcolor);
        }
        
        // DETAIL COUNTER
        if (detail <= 90) {
            //Look for button presses: Kids - don't do that at home (you should normally
            //never do something like this in your draw event... but since this is just
            //for debug...
            if (keyboard_check_pressed(detail) && keyboard_check(vk_shift)) {
               self.dbgcntx2 = key;
            }
            if (detail >= 58) detail = 65;
            instsummary = instsummary + "Press SHIFT+"+chr(detail)+" for details#";
            detail = detail+1;
        }
        // /DT
        
        var instsummary = instsummary  + "---------------------------#";
        
        //Add to summary
        draw_text(self.dbg_left+20,offs,instsummary);
        offs = offs + string_height(instsummary);
        
        key = ds_map_find_next(mapToUse, key);
    }
}
//HEADER
draw_rectangle_colour(self.dbg_left,self.dbg_top,self.dbg_left+20+string_width(headstr)+20,self.dbg_top+20+string_height(headstr)+5,c_black,c_black,c_black,c_black,false);
draw_text(self.dbg_left+20,self.dbg_top+20,headstr);
