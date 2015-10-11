///htme_debugoverlayStateInstInvisible();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Draw debug information about players
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
   htme_doDrawInstanceTable("INSTANCES OF PLAYER "+string(htme_getPlayerNumber(self.dbgcntx))+"("+self.dbgcntx+")",0,self.dbgcntx,true);
} else {
   draw_set_halign(fa_left);
   //HEADER
   var headstr = "PLAYERS#========#";
   var offs = self.dbg_top+20+string_height(headstr)+10;
   var keynum = 0;
   if (self.isServer) {
     var playermap = self.playermap;
     var key= ds_map_find_first(playermap);
     for(var i=0; i<ds_map_size(playermap); i+=1) {
         var hash = ds_map_find_value(playermap,key);
         var r = ds_map_find_value(playerrooms,key);
         var playernum = htme_getPlayerNumber(hash);
         
         keynum++;
         if (keynum < 10) {
            //Look for button presses: Kids - don't do that at home (you should normally
            //never do something like this in your draw event... but since this is just
            //for debug...
            if (keyboard_check_pressed(ord(string(keynum))) && keyboard_check(vk_shift)) {
               self.dbgcntx = hash;
            }
            if (keyboard_check_pressed(ord(string(keynum))) && keyboard_check(vk_control)) {
                if (key != "0:0") {
                    //KICK
                    htme_serverDisconnect(hash);
                }
            }
            var press = "Press SHIFT+"+string(keynum)+" for instance list";
            if (key != "0:0")
                press = press + "#Press STRG+"+string(keynum)+" TO KICK";
         } else {
            var press = "";
         }
         
         if (!is_undefined(ds_map_find_value(self.kickmap,key))) {
            var kick = "Will be KICKED in "+ string(ds_map_find_value(self.kickmap,key))  +" steps.";
         } else {
            var kick = "";
         }
         
         if (key == "0:0") {
            var str = "Player "+string(playernum)+" : "+hash+" - (SERVER) (LOCAL)#ROOM: "+room_get_name(r)+"#"+press+"#"+kick+"#---------------------------";
         } else {
            var str = "Player "+string(playernum)+" : "+hash+" - IP: "+key+"#ROOM: "+room_get_name(r)+"#"+press+"#"+kick+"#---------------------------
           ";
         }
         
         draw_text(self.dbg_left+20,offs,str);
         offs = offs + string_height(str);
         key = ds_map_find_next(playermap, key);
     }
   } else {
     var playerlist = htme_getPlayers();
     for (var i=0; i<ds_list_size(playerlist);i++) {
         var hash = ds_list_find_value(playerlist,i);
         var playernum = htme_getPlayerNumber(hash);
         
         keynum++;
         if (keynum < 10) {
            if (keyboard_check_pressed(ord(string(keynum))) && keyboard_check(vk_shift)) {
               self.dbgcntx = hash;
            }
            var press = "Press SHIFT+"+string(keynum)+" for instance list";
         } else {
            var press = "";
         }
         
         var islocal = ""; 
         if (hash == self.playerhash) islocal = "(LOCAL)"; 
         var isserver = "";
         if (playernum == 1) isserver = "(SERVER)";
         var str = "Player "+string(playernum)+" : "+hash+" - "+isserver+" "+islocal+"#"+press+"#---------------------------";
         draw_text(self.dbg_left+20,offs,str);
         offs = offs + string_height(str);
     }
   }
   draw_rectangle_colour(self.dbg_left,self.dbg_top,self.dbg_left+20+string_width(headstr)+20,self.dbg_top+20+string_height(headstr)+5,c_black,c_black,c_black,c_black,false);
   draw_text(self.dbg_left+20,self.dbg_top+20,headstr)
}
