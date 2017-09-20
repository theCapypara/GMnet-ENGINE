///htme_debugoverlayStateMain();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Draw the off screen of the debug overlay
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
var str = "TOGGLE GMnet CORE OVERLAY (F12)";
draw_set_colour(c_black);
draw_rectangle(self.dbg_right-22-string_width(str),self.dbg_top+18,self.dbg_right-20,self.dbg_top+18+string_height(str)+2,false);
draw_set_colour(c_white);
draw_text(self.dbg_right-20,self.dbg_top+20,str);
draw_set_halign(fa_left);
