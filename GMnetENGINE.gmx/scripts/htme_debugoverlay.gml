///htme_debugoverlay();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Draw the debug overlay, if enabled
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

if (!self.debugoverlay || !self.started) exit;

self.dbgcolor = c_white;
self.dbgcolor_a = c_red;
draw_set_font(-1);

//Get screen coordinates
if (!view_enabled) {
   var self.dbg_left = 0;
   var self.dbg_right = room_width;
   var self.dbg_top = 0;
   var self.dbg_bottom = room_height;
} else {
   var self.dbg_left = view_xview;
   var self.dbg_right = view_xview+view_wview;
   var self.dbg_top = view_yview;
   var self.dbg_bottom = view_yview+view_hview;
}

if (self.dbgstate != vk_f12) {
    //Draw transparent overlay
    draw_set_colour(c_black);
    draw_set_alpha(0.4);
    draw_rectangle(self.dbg_left,self.dbg_top,self.dbg_right,self.dbg_bottom,false);
    
    draw_set_colour(self.dbgcolor);
    draw_set_alpha(1);
}

switch (self.dbgstate) {
    case vk_f12:
        htme_doOff();
    break;
    case vk_f1:
        htme_doInstAll();
    break;
    case vk_f2:
        htme_doInstVisible();
    break;
    case vk_f3:
        htme_doPlayers();
    break;
    case vk_f4:
        htme_doInstInvisible();
    break;
    case vk_f5:
        htme_doInstCached();
    break;
    case vk_f6:
        htme_doGlobalSync();
    break;
    case vk_f7:
        htme_doChat();
    break;
    case vk_f8:
        htme_doSignedPackets();
    break;
    case vk_f11:
        if (!self.isServer) {
            htme_clientDisconnect();
            self.dbgstate = vk_f12;
        }
        else {
            htme_dotbd();
        }
    break;
    case vk_nokey:
        htme_doMain();
    break;
    default:
        htme_dotbd();
    break;
}
