///htme_doGlobalSync();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Draw debug information about lists and maps:
**      * Currently displays number of all lists and maps.
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
var headstr = "MAPS AND LISTS#High numbers indicate memory leaks.#========#";
var offs = self.dbg_top+20+string_height(headstr)+10;

var countlist=0;
var countmap=0;
for (var i=0; i<5000; i+=1) {
    if (ds_exists(i,ds_type_list)) {
        countlist+=1;       
    }    
    if (ds_exists(i,ds_type_map)) {
        countmap+=1;     
    }
}

var str = "Current list count: " + string(countlist) + "#--------#" + "Current map count: " + string(countmap);
draw_text(self.dbg_left+20,offs,str);
offs = offs + string_height(str);

draw_rectangle_colour(self.dbg_left,self.dbg_top,self.dbg_left+20+string_width(headstr)+20,self.dbg_top+20+string_height(headstr)+5,c_black,c_black,c_black,c_black,false);
draw_text(self.dbg_left+20,self.dbg_top+20,headstr);
