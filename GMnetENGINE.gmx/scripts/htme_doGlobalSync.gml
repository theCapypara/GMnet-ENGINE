///htme_doGlobalSync();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Draw debug information about global sync
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
htme_doMain();
draw_set_halign(fa_left);
//HEADER
var headstr = "GLOBAL SYNC#List of variables in the global sync pool#========#";
var offs = self.dbg_top+20+string_height(headstr)+10;

var key= ds_map_find_first(self.globalsync);
for(var i=0; i<ds_map_size(self.globalsync); i+=1) {
    var value = ds_map_find_value(self.globalsync,key);
    var datatype = ds_map_find_value(self.globalsync_datatypes,key);
    var datatype_str = "unknown";
    switch (datatype) {
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
    }
    var str = key+" - ("+datatype_str+")#"+string(value)+"#---------------------------";
    draw_text(self.dbg_left+20,offs,str);
    offs = offs + string_height(str);
    key = ds_map_find_next(self.globalsync, key);
}

draw_rectangle_colour(self.dbg_left,self.dbg_top,self.dbg_left+20+string_width(headstr)+20,self.dbg_top+20+string_height(headstr)+5,c_black,c_black,c_black,c_black,false);
draw_text(self.dbg_left+20,self.dbg_top+20,headstr);
