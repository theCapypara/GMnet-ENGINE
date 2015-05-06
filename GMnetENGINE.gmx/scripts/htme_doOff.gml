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
var str = "TOGGLE OVERLAY (F12)";
draw_text(self.dbg_right-20,self.dbg_top+20,str);
draw_set_halign(fa_left);