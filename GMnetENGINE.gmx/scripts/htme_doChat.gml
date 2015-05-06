///htme_doChat();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Draw debug information about incoming CHAT messages.
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
    var headstr = "CHAT API CHANNELS#========#Scroll up: PAGE UP - Scroll down: PAGE DOWN - Page "+string(self.dbgpage+1)+"#========#";
    var base = self.dbg_top+20+string_height(headstr)+10;
    var offs = base-((self.dbg_bottom-base)*(self.dbgpage));
    var keynum = -1;
    var channel = ds_map_find_first(self.chatQueues);
    for(var i=0; i<ds_map_size(self.chatQueues); i+=1) {
        var queue = ds_map_find_value(self.chatQueues,channel);
        
        var str = "#---------------------------#";
        str = "CHANNEL "+channel;
        str = str + "#Unprocessed incoming messages: " + string(ds_queue_size(queue));
        if (ds_queue_size(queue) > 0)
            str = str + "#First message: " + ds_queue_head(queue);
        else
            str = str + "#First message: <none>";
        str = str + "#---------------------------#";
        
        draw_text(self.dbg_left+20,offs,str);
        offs = offs + string_height(str);
        channel = ds_map_find_next(self.chatQueues,channel);
    }
    draw_rectangle_colour(self.dbg_left,self.dbg_top,self.dbg_left+20+string_width(headstr)+20,self.dbg_top+20+string_height(headstr)+5,c_black,c_black,c_black,c_black,false);
    draw_text(self.dbg_left+20,self.dbg_top+20,headstr)
}
