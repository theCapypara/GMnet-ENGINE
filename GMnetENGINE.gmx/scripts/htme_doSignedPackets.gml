///htme_doGlobalSync(show_inbox);

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
**      show_inbox             bool       show inbox instead of sent.
**
**  Returns:
**      <Nothing>
**
*/
htme_doMain();
if (self.dbgcntx != "") {
   //
} else {

    if (!argument0) {
    
        draw_set_halign(fa_left);
        //HEADER
        var headstr = "SIGNED PACKETS SENT#(history/cache of sent signed packets)#========#Scroll up: PAGE UP - Scroll down: PAGE DOWN - Page "+string(self.dbgpage+1)+"#========#";
        var base = self.dbg_top+20+string_height(headstr)+10;
        var offs = base-((self.dbg_bottom-base)*(self.dbgpage));
        var keynum = -1;
        
        //ALL MAPS OUT
        var key = ds_map_find_first(self.sPcountOUT);
        for(var i=0; i<ds_map_size(self.sPcountOUT); i+=1) {
            var player = ds_map_find_value(self.sPcountOUT,key);
            
            var str = "##---------------------------#";
            str = str + string(ds_map_find_value(self.playermap,key))+"("+key+")";
            str = str + "#---------------------------#";
            
            str = str + "LAST SENT: "+string(player[? "n"])+"##";
            if (!is_undefined(player[? "n"])) {
                for (j=player[? "n"];j>player[? "n"]-500;j--) {
                    if (j < 0) break;
                    var buff = ds_map_find_value(player,j);
                    str = str + string(j)+": ";
                    var packet_name = "";
                    buffer_seek(buff, buffer_seek_start, 0);
                    var packetid = buffer_read(buff, buffer_s8);
                    switch (packetid) {
                        case htme_packet.PING:
                            packet_name = "PING";
                            break;
                        case htme_packet.CLIENT_REQUESTCONNECT:
                            packet_name = "CLIENT_REQUESTCONNECT";
                            break;
                        case htme_packet.SERVER_CONREQACCEPT:
                            packet_name = "SERVER_CONREQACCEPT";
                            break;
                        case htme_packet.SERVER_GREETINGS:
                            packet_name = "SERVER_GREETINGS";
                            break;
                        case htme_packet.SERVER_PLAYERCONNECTED:
                            packet_name = "SERVER_PLAYERCONNECTED";
                            break;
                        case htme_packet.INSTANCE_VARGROUP:
                            packet_name = "INSTANCE_VARGROUP";
                            break;
                        case htme_packet.CLIENT_INSTANCEREMOVED:
                            packet_name = "CLIENT_INSTANCEREMOVED";
                            break;
                        case htme_packet.SERVER_INSTANCEREMOVED:
                            packet_name = "SERVER_INSTANCEREMOVED";
                            break;
                        case htme_packet.CLIENT_ROOMCHANGE:
                            packet_name = "CLIENT_ROOMCHANGE";
                            break;
                        case htme_packet.SERVER_PLAYERDISCONNECTED:
                            packet_name = "SERVER_PLAYERDISCONNECTED";
                            break;
                        case htme_packet.GLOBALSYNC:
                            packet_name = "GLOBALSYNC";
                            break;
                        case htme_packet.SERVER_KICKREQ:
                            packet_name = "SERVER_KICKREQ";
                            break;
                        case htme_packet.CLIENT_BYE:
                            packet_name = "CLIENT_BYE";
                            break;
                        case htme_packet.SERVER_BROADCAST:
                            packet_name = "SERVER_BROADCAST";
                            break;
                        case htme_packet.CHAT_API:
                            packet_name = "CHAT_API";
                            break;
                        case htme_packet.CLIENT_GREETINGS:
                            packet_name = "CLIENT_GREETINGS";
                            break;
                        case htme_packet.SERVER_PLEASE_RESYNC:
                            packet_name = "SERVER_PLEASE_RESYNC";
                            break;
                        case htme_packet.SIGNEDPACKET_NEW:
                            packet_name = "SIGNEDPACKET_NEW";
                            break;
                        case htme_packet.SIGNEDPACKET_NEW_CMD:
                            packet_name = "SIGNEDPACKET_NEW_CMD";
                            break;
                        case htme_packet.SIGNEDPACKET:
                            packet_name = "SIGNEDPACKET";
                            break;
                        case htme_packet.SIGNEDPACKET_ACCEPTED:
                            packet_name = "SIGNEDPACKET_ACCEPTED";
                            break;
                        case htme_packet.SIGNEDPACKET_NEW_CMD_REQ:
                            packet_name = "SIGNEDPACKET_NEW_CMD_REQ";
                            break;
                        case htme_packet.SIGNEDPACKET_NEW_CMD_MISS:
                            packet_name = "SIGNEDPACKET_NEW_CMD_MISS";
                            break;
                        default:
                            packet_name = "UNKNOWN ("+string(packetid)+")";
                            break;
                    }
                    buffer_seek(buff, buffer_seek_end, 0);
                    var enc = buffer_base64_encode(buff,0,buffer_tell(buff));
                    
                    for (var h =30;h<string_length(enc);h+=29) {
                        enc = string_insert("#", enc,h);
                    }
                    str = str + string(packet_name)+"#"+enc+"##"
                    
                }
            }
            
            draw_text(self.dbg_left+20,offs,str);
            offs = offs + string_height(str);
            
            key = ds_map_find_next(self.sPcountOUT, key);
        }
        
        draw_rectangle_colour(self.dbg_left,self.dbg_top,self.dbg_left+20+string_width(headstr)+20,self.dbg_top+20+string_height(headstr)+5,c_black,c_black,c_black,c_black,false);
        draw_text(self.dbg_left+20,self.dbg_top+20,headstr);
    
    } else {
    
        draw_set_halign(fa_left);
        //HEADER
        var headstr = "SIGNED PACKETS INBOX#(signed packets waiting to be processed)#========#Scroll up: PAGE UP - Scroll down: PAGE DOWN - Page "+string(self.dbgpage+1)+"#========#";
        var base = self.dbg_top+20+string_height(headstr)+10;
        var offs = base-((self.dbg_bottom-base)*(self.dbgpage));
        var keynum = -1;
        
        //ALL MAPS IN
        var key = ds_map_find_first(self.sPcountIN);
        for(var i=0; i<ds_map_size(self.sPcountIN); i+=1) {
            var player = ds_map_find_value(self.sPcountIN,key);
            
            var str = "##---------------------------#";
            str = str + string(ds_map_find_value(self.playermap,key))+"("+key+")";
            str = str + "#---------------------------#";
            
            str = str + "WE NEED NEXT: "+string(player[? "n"])+"##";
            var prio = ds_priority_create();
            ds_priority_copy(prio,player[? "buffs"]);
            var priority = ds_priority_find_priority(prio,ds_priority_find_min(prio));
            var buff = ds_priority_delete_min(prio);
            while (!ds_priority_empty(prio)) {
                str = str + string(priority)+": ";
                var packet_name = "";
                buffer_seek(buff, buffer_seek_start, 0);
                buffer_read(buff, buffer_s8);
                buffer_read(buff, buffer_u32);
                var packetid = buffer_read(buff, buffer_s8);
                switch (packetid) {
                    case htme_packet.PING:
                        packet_name = "PING";
                        break;
                    case htme_packet.CLIENT_REQUESTCONNECT:
                        packet_name = "CLIENT_REQUESTCONNECT";
                        break;
                    case htme_packet.SERVER_CONREQACCEPT:
                        packet_name = "SERVER_CONREQACCEPT";
                        break;
                    case htme_packet.SERVER_GREETINGS:
                        packet_name = "SERVER_GREETINGS";
                        break;
                    case htme_packet.SERVER_PLAYERCONNECTED:
                        packet_name = "SERVER_PLAYERCONNECTED";
                        break;
                    case htme_packet.INSTANCE_VARGROUP:
                        packet_name = "INSTANCE_VARGROUP";
                        break;
                    case htme_packet.CLIENT_INSTANCEREMOVED:
                        packet_name = "CLIENT_INSTANCEREMOVED";
                        break;
                    case htme_packet.SERVER_INSTANCEREMOVED:
                        packet_name = "SERVER_INSTANCEREMOVED";
                        break;
                    case htme_packet.CLIENT_ROOMCHANGE:
                        packet_name = "CLIENT_ROOMCHANGE";
                        break;
                    case htme_packet.SERVER_PLAYERDISCONNECTED:
                        packet_name = "SERVER_PLAYERDISCONNECTED";
                        break;
                    case htme_packet.GLOBALSYNC:
                        packet_name = "GLOBALSYNC";
                        break;
                    case htme_packet.SERVER_KICKREQ:
                        packet_name = "SERVER_KICKREQ";
                        break;
                    case htme_packet.CLIENT_BYE:
                        packet_name = "CLIENT_BYE";
                        break;
                    case htme_packet.SERVER_BROADCAST:
                        packet_name = "SERVER_BROADCAST";
                        break;
                    case htme_packet.CHAT_API:
                        packet_name = "CHAT_API";
                        break;
                    case htme_packet.CLIENT_GREETINGS:
                        packet_name = "CLIENT_GREETINGS";
                        break;
                    case htme_packet.SERVER_PLEASE_RESYNC:
                        packet_name = "SERVER_PLEASE_RESYNC";
                        break;
                    case htme_packet.SIGNEDPACKET_NEW:
                        packet_name = "SIGNEDPACKET_NEW";
                        break;
                    case htme_packet.SIGNEDPACKET_NEW_CMD:
                        packet_name = "SIGNEDPACKET_NEW_CMD";
                        break;
                    case htme_packet.SIGNEDPACKET:
                        packet_name = "SIGNEDPACKET";
                        break;
                    case htme_packet.SIGNEDPACKET_ACCEPTED:
                        packet_name = "SIGNEDPACKET_ACCEPTED";
                        break;
                    case htme_packet.SIGNEDPACKET_NEW_CMD_REQ:
                        packet_name = "SIGNEDPACKET_NEW_CMD_REQ";
                        break;
                    case htme_packet.SIGNEDPACKET_NEW_CMD_MISS:
                        packet_name = "SIGNEDPACKET_NEW_CMD_MISS";
                        break;
                    default:
                        packet_name = "UNKNOWN ("+string(packetid)+")";
                        break;
                }
                buffer_seek(buff, buffer_seek_end, 0);
                var enc = buffer_base64_encode(buff,0,buffer_tell(buff));
                
                for (var h =30;h<string_length(enc);h+=29) {
                    enc = string_insert("#", enc,h);
                }
                str = str + string(packet_name)+"#"+enc+"##"
                
                priority = ds_priority_find_priority(prio,ds_priority_find_min(prio));
                buff = ds_priority_delete_min(prio);
            }
            ds_priority_destroy(prio);
            
            draw_text(self.dbg_left+20,offs,str);
            offs = offs + string_height(str);
            
            key = ds_map_find_next(self.sPcountOUT, key);
        }
        
        draw_rectangle_colour(self.dbg_left,self.dbg_top,self.dbg_left+20+string_width(headstr)+20,self.dbg_top+20+string_height(headstr)+5,c_black,c_black,c_black,c_black,false);
        draw_text(self.dbg_left+20,self.dbg_top+20,headstr);
    
    }
}
