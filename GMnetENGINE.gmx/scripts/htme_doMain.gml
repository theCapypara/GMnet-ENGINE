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

str = "CHAT API CHANNELS (F7) #========#";
if (self.dbgstate = vk_f7) draw_set_colour(self.dbgcolor_a);
draw_text(self.dbg_right-20,offs,str);
if (self.dbgstate = vk_f7) draw_set_colour(self.dbgcolor);
offs = offs + string_height(str);

str = "SIGNED PACKETS SENT (F8) #========#";
if (self.dbgstate = vk_f8) draw_set_colour(self.dbgcolor_a);
draw_text(self.dbg_right-20,offs,str);
if (self.dbgstate = vk_f8) draw_set_colour(self.dbgcolor);
offs = offs + string_height(str);

str = "SIGNED PACKETS INBOX (F9) #========#";
if (self.dbgstate = vk_f9) draw_set_colour(self.dbgcolor_a);
draw_text(self.dbg_right-20,offs,str);
if (self.dbgstate = vk_f9) draw_set_colour(self.dbgcolor);
offs = offs + string_height(str);
/*
str = "TOOLKIT (F10) #========#";
if (self.dbgstate = vk_f10) draw_set_colour(self.dbgcolor_a);
draw_text(self.dbg_right-20,offs,str);
if (self.dbgstate = vk_f10) draw_set_colour(self.dbgcolor);
offs = offs + string_height(str);*/

if (!self.isServer) {
    str = "DISCONNECT (F11) #========#";
    if (self.dbgstate = vk_f10) draw_set_colour(self.dbgcolor_a);
    draw_text(self.dbg_right-20,offs,str);
    if (self.dbgstate = vk_f10) draw_set_colour(self.dbgcolor);
    offs = offs + string_height(str);
}

str = "TOGGLE GMnet CORE OVERLAY (F12) #========";
draw_text(self.dbg_right-20,offs,str);

draw_set_halign(fa_left);

if (self.dbgstate = vk_nokey) {
    var headstr2 = "GMnet CORE#DEBUG OVERLAY#========#Welcome to the debug overlay.#To disable it, set self.debugoverlay to false#in htme_init.";
    draw_rectangle_colour(self.dbg_left,self.dbg_top,self.dbg_left+20+string_width(headstr2)+20,self.dbg_top+20+string_height(headstr2)+5,c_black,c_black,c_black,c_black,false);
    draw_text(self.dbg_left+20,self.dbg_top+20,headstr2)
}
