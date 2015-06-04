///htme_syncSingleVarGroup(group,target)

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Forces the sync of a single variable group of an instance
**      Only use internally
**  
**  Usage:
**       <see above>
**
**  Arguments:
**      group     ds_map            vargroup to sync
**      target    string/real       playerhash to send to or real "all" for all
**                                  (Client will always send to server)
**
**  Returns:
**      <Nothing>
**
*/

var group = argument0;
var target = argument1;

/**RETRIEVE INFORMATION**/
var inst_hash = group[? "instancehash"];
var inst = group[? "instance"];
if (instance_exists(inst)) {
    var inst_groups = (inst).htme_mp_groups;
    var inst_object = (inst).htme_mp_object;
    var inst_player = (inst).htme_mp_player;   
    var inst_stayAlive =  (inst).htme_mp_stayAlive;
} else if (self.isServer) {
    var backupEntry = ds_map_find_value(self.serverBackup,inst_hash);
    if (ds_exists(backupEntry,ds_type_map)) {
        var inst_groups = backupEntry[? "groups"];
        var inst_object = backupEntry[? "object"];
        var inst_player = backupEntry[? "player"];      
        var inst_stayAlive = backupEntry[? "stayAlive"];
    } else {
        if (is_undefined(inst_hash) || is_undefined(group[? name])) {
            htme_debugger("htme_syncSingleVarGroup",htme_debug.WARNING,"CORRUPTED VARGROUP! CONTENTS: "+json_encode(group));
        } else {
            htme_debugger("htme_syncSingleVarGroup",htme_debug.WARNING,"Could not sync var-group "+group[? "name"]+" of instance "+inst_hash+". MISSING BACKUP ENTRY!");
        }
    }
} else {
    if (is_undefined(inst_hash) || is_undefined(group[? name])) {
        htme_debugger("htme_syncSingleVarGroup",htme_debug.WARNING,"CORRUPTED VARGROUP! CONTENTS: "+json_encode(group));
    } else {
        htme_debugger("htme_syncSingleVarGroup",htme_debug.WARNING,"Could not sync var-group "+group[? "name"]+" of instance "+inst_hash+". MISSING INSTANCE!");
    }
    exit;
}

/** GET ROOM OF PLAYER THAT CONTROLS INSTANCE **/
if (self.isServer) {
   var port_ip_player = htme_ds_map_find_key(self.playermap,inst_player);
   var inst_room = ds_map_find_value(self.playerrooms,port_ip_player);
   if (is_undefined(inst_room)) inst_room = -1;
}

/** START SYNCING **/
htme_debugger("htme_syncSingleVarGroup",htme_debug.DEBUG,"Syncing a var group...");
/** PACKET INSTANCE_VARGROUP
 * s8 -> id
 * string -> instance hash
 * string -> player hash
 * u16 -> room
 * string -> groupname
 * u16 -> object
 * bool -> stayAlive
 * f32 -> tolerance
 * u16 -> datatype
 * u8 -> Number of vars
 * {
 *   string -> var_name
 *   datatype -> value
 * }
 * var_name and Number of vars only for default datatypes!
 **/
 var cmd_list = ds_list_create();
//Write header
cmd_list[| 0] = buffer_s8;
cmd_list[| 1] = htme_packet.INSTANCE_VARGROUP;
//Write instance hash
cmd_list[| 2] = buffer_string;
cmd_list[| 3] = inst_hash;
//Write player
cmd_list[| 4] = buffer_string;
cmd_list[| 5] = inst_player;
//Write groupname
cmd_list[| 6] = buffer_string;
cmd_list[| 7] = group[? "name"];
//Write object id
cmd_list[| 8] = buffer_u16;
cmd_list[| 9] = inst_object;
//Write stayAlive
cmd_list[| 10] = buffer_bool;
cmd_list[| 11] = inst_stayAlive;
//Write tolerance
cmd_list[| 12] = buffer_f32;
cmd_list[| 13] = group[? "tolerance"];
//Write datatype
cmd_list[| 14] = buffer_u16; 
cmd_list[| 15] = group[? "datatype"];

//Server: Sync in clientmode if local instance
if (self.isServer && inst_player != self.playerhash) {
   if (!htme_serverSyncSingleVarGroup(group,cmd_list)) {
      ds_list_destroy(cmd_list)
      exit;
   }
} else {
   if (!htme_clientSyncSingleVarGroup(group,cmd_list)) {
    ds_list_destroy(cmd_list);
    exit;
   }
}

var cat = inst_hash+"_"+group[? "name"]

/** Check type of delivery **/
if (group[? "type"] == mp_type.IMPORTANT || group[? "type"] == mp_type.SMART) {
    //Send via signed
    if (self.isServer) {
        if (is_real(target)) {
            var port_ip_player = htme_ds_map_find_key(self.playermap,inst_player);
            if (!htme_isStayAlive(inst_hash)) {
               htme_serverCreateSPForAllCheckRoom(cmd_list,port_ip_player,inst_room,cat,group[? "interval"]/2);
            } else {
              htme_createSignedPacket(cmd_list,all,cat,port_ip_player,group[? "interval"]/2);
            }
        } else if (target != inst_player) {
            if (htme_serverPlayerIsInRoom(target,inst_room) || htme_isStayAlive(inst_hash)) {
                htme_createSignedPacket(cmd_list,target,cat,"",group[? "interval"]/2);
            }
        }
    } else {
        htme_createSignedPacket(cmd_list,noone,cat,"",group[? "interval"]/2);
    }
} else {
    //Send normally
    htme_fillSignedPacketBuffer(self.buffer,cmd_list);
    ds_list_destroy(cmd_list);
    if (self.isServer) {
        if (is_real(target)) {
            var port_ip_player = htme_ds_map_find_key(self.playermap,inst_player);
            if (!htme_isStayAlive(inst_hash)) {
               htme_serverSendBufferToAllExcept(port_ip_player,inst_room);
            } else {
              htme_serverSendBufferToAllExcept(port_ip_player);
            }
        } else if (target != inst_player) {
            if (htme_serverPlayerIsInRoom(target,inst_room) || htme_isStayAlive(inst_hash)) {
                var ip = htme_playerMapIP(target);
                var port = htme_playerMapPort(target);
                network_send_udp( self.socketOrServer, ip, port, self.buffer, buffer_tell(self.buffer) );
            }
        }
    } else {
        network_send_udp( self.socketOrServer, self.server_ip, self.server_port, self.buffer, buffer_tell(self.buffer) );
    }
}
