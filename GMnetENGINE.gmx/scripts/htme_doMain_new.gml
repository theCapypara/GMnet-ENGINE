///htme_debugoverlayStateMain();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Draw the main screen of the debug overlay
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      <None>
**
**  Returns:
**      <Nothing>
**
*/
//Operation mode
draw_set_halign(fa_right);

var offs = self.dbg_top+20;

if (self.isServer) var str = "MODE: SERVER#========#";
else               var str = "MODE: CLIENT#========#";
draw_text(self.dbg_right-20,offs,str);
offs = offs + string_height(str);

str = "ALL INSTANCES (F1) #========#";
if (self.dbgstate = vk_f1) draw_set_colour(self.dbgcolor_a);
draw_text(self.dbg_right-20,offs,str);
if (self.dbgstate = vk_f1) draw_set_colour(self.dbgcolor);
offs = offs + string_height(str);

str = "VISIBLE INSTANCES (F2) #========#";
if (self.dbgstate = vk_f2) draw_set_colour(self.dbgcolor_a);
draw_text(self.dbg_right-20,offs,str);
if (self.dbgstate = vk_f2) draw_set_colour(self.dbgcolor);
offs = offs + string_height(str);

str = "PLAYERS (F3) #========#";
if (self.dbgstate = vk_f3) draw_set_colour(self.dbgcolor_a);
draw_text(self.dbg_right-20,offs,str);
if (self.dbgstate = vk_f3) draw_set_colour(self.dbgcolor);
offs = offs + string_height(str);

str = "INVISIBLE INSTANCES (F4) #========#";
if (self.dbgstate = vk_f4) draw_set_colour(self.dbgcolor_a);
draw_text(self.dbg_right-20,offs,str);
if (self.dbgstate = vk_f4) draw_set_colour(self.dbgcolor);
offs = offs + string_height(str);

str = "INSTANCES IN CACHE (F5) #========#";
if (self.dbgstate = vk_f5) draw_set_colour(self.dbgcolor_a);
draw_text(self.dbg_right-20,offs,str);
if (self.dbgstate = vk_f5) draw_set_colour(self.dbgcolor);
offs = offs + string_height(str);

str = "GLOBAL SYNC (F6) #========#";
if (self.dbgstate = vk_f6) draw_set_colour(self.dbgcolor_a);
draw_text(self.dbg_right-20,offs,str);
if (self.dbgstate = vk_f6) draw_set_colour(self.dbgcolor);
offs = offs + string_height(str);

str = "PACKET HISTORY (F7) #========#";
if (self.dbgstate = vk_f7) draw_set_colour(self.dbgcolor_a);
draw_text(self.dbg_right-20,offs,str);
if (self.dbgstate = vk_f7) draw_set_colour(self.dbgcolor);
offs = offs + string_height(str);

str = "SIGNED PACKET QUEUE (F8) #========#";
if (self.dbgstate = vk_f8) draw_set_colour(self.dbgcolor_a);
draw_text(self.dbg_right-20,offs,str);
if (self.dbgstate = vk_f8) draw_set_colour(self.dbgcolor);
offs = offs + string_height(str);

str = "EVENT LOG (F9) #========#";
if (self.dbgstate = vk_f9) draw_set_colour(self.dbgcolor_a);
draw_text(self.dbg_right-20,offs,str);
if (self.dbgstate = vk_f9) draw_set_colour(self.dbgcolor);
offs = offs + string_height(str);

str = "TOOLKIT (F10) #========#";
if (self.dbgstate = vk_f10) draw_set_colour(self.dbgcolor_a);
draw_text(self.dbg_right-20,offs,str);
if (self.dbgstate = vk_f10) draw_set_colour(self.dbgcolor);
offs = offs + string_height(str);

str = "TOGGLE OVERLAY (F12) #========";
draw_text(self.dbg_right-20,offs,str);

draw_set_halign(fa_left);


/*
var mapToUse = self.globalInstances;

var key= ds_map_find_first(mapToUse);
//This will loop through all global instances
for(var i=0; i<ds_map_size(mapToUse); i+=1) {
    var inst = ds_map_find_value(mapToUse,key);
    var isExisting = false;
    var isLocal = false;
    if (instance_exists(inst)) {
        var inst_groups = (inst).htme_mp_groups;
        var inst_object = (inst).htme_mp_object;
        var inst_player = (inst).htme_mp_player;
        var isLocal;
        with inst {isLocal = htme_isLocal();}
        if ((inst).visible && (inst).sprite_index != -1) {
           var insttext = object_get_name(inst_object) + " -ID: " + string(inst) + "#"
               + "x,y: " + string((inst).x)+","+string((inst).y) + "#"
               + "PLAYER:" + inst_player + " #"
               + "HASH:" + key + " #"
               var isExisting = true;
        } else {
            inst_invis = inst_invis + htme_debugoverlay_createMicro(inst_player,inst_object,inst,key) + "#";
        }
    } else if (self.isServer) {
        var backupEntry = ds_map_find_value(self.serverBackup,key);
        var inst_groups = backupEntry[? "groups"];
        var inst_object = backupEntry[? "object"];
        var inst_player = backupEntry[? "player"];                
        var inst_stayAlive = backupEntry[? "stayAlive"];
        inst_nonexist = inst_nonexist + htme_debugoverlay_createMicro(inst_player,inst_object,-1,key) + "#";
    } else {key = ds_map_find_next(mapToUse, key);continue;}
   
    //Cool! Instance loaded. Now loop through all variable groups
    var inner_key= ds_map_find_first(inst_groups);
    //This will loop through all variable groups of this instance
    if (isExisting && isLocal) {
       insttext = insttext +
           + "==========#"
           + "VARGROUPS: #";   
    }
    for(var j=0; j<ds_map_size(inst_groups); j+=1) {
        var group = ds_map_find_value(inst_groups,inner_key);
        if (isExisting && isLocal) {
           insttext = insttext +
               group[? "name"] + ": Syncing in " + string(group[? "__counter"]) + "#";
        }
        inner_key = ds_map_find_next(inst_groups,inner_key);
    }
    if (isExisting) {
       if (isLocal) {
          draw_set_colour(self.dbgcolor_a);
       }
       draw_text((inst).x-(inst).sprite_xoffset+(inst).sprite_width,(inst).y-(inst).sprite_yoffset+(inst).sprite_height,insttext);
       draw_set_colour(self.dbgcolor);
    }
    key = ds_map_find_next(mapToUse, key);
}
*/

/*


//If server: Clients
if (self.isServer) {
     var mapToUse = self.playermap;
     var key= ds_map_find_first(mapToUse);
     str = "PLAYERS (F3): #";
     //This will loop through all global instances
     for(var i=0; i<ds_map_size(mapToUse); i+=1) {
         var hash = ds_map_find_value(mapToUse,key);
         str = str + key + "--" + hash + "#";
         key = ds_map_find_next(mapToUse, key);
         //TODO: Add player room
     }
     str = str + "========";
     draw_text(self.dbg_right-20,self.dbg_top+20+offs,str);
     offs += string_height(str);
}
//If client: Server
else {
     str = "Server -- IP: "+self.server_ip+" -PORT: "+string(self.server_port)+ "#========";
     draw_text(self.dbg_right-20,self.dbg_top+20+offs,str);
     offs += string_height(str);
}

*/