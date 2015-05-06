///htme_doGlobalSync();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Draw debug information about signed packets
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
if (self.dbgcntx != "") {
   //
} else {
    draw_set_halign(fa_left);
    //HEADER
    var headstr = "SIGNED PACKET QUEUE#========#Scroll up: PAGE UP - Scroll down: PAGE DOWN - Page "+string(self.dbgpage+1)+"#========#";
    var base = self.dbg_top+20+string_height(headstr)+10;
    var offs = base-((self.dbg_bottom-base)*(self.dbgpage));
    var keynum = -1;
    for(var i=0; i<ds_list_size(self.signedPackets); i+=1) {
        var packet = ds_list_find_value(self.signedPackets,i);
        var contents = "";
        for (var j=0;j<ds_list_size(packet[? "cmd_list"]); j+=1) {
            if ( j%2 == 0 ) {
               contents = contents + string(ds_list_find_value(packet[? "cmd_list"],j))+",";
            }
        }
        var str = "#---------------------------#";
        str = "(" + packet[? "hash"] + " - " + packet[? "cat"] + ") : to " + packet[? "target"];
        str = str + "#CONTENTS: " + contents;
        str = str + "#---------------------------#";
        
        draw_text(self.dbg_left+20,offs,str);
        offs = offs + string_height(str);
    }
    draw_rectangle_colour(self.dbg_left,self.dbg_top,self.dbg_left+20+string_width(headstr)+20,self.dbg_top+20+string_height(headstr)+5,c_black,c_black,c_black,c_black,false);
    draw_text(self.dbg_left+20,self.dbg_top+20,headstr)
}