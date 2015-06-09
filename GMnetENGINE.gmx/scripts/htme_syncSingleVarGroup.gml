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

//Check if we actually know who we are
if (!self.isServer && self.playerhash == "") {
    htme_debugger("htme_syncSingleVarGroup",htme_debug.INFO,"Tried to send vargroup but we are not continuing: We don't have a playerhash yet.");    
    exit;
}

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

if (is_undefined(inst_player)) {
    htme_debugger("htme_syncSingleVarGroup",htme_debug.WARNING,"Could not sync var-group "+group[? "name"]+" of instance "+inst_hash+". MISSING PLAYER! FIXME!");
    exit;
}

/** GET ROOM OF PLAYER THAT CONTROLS INSTANCE **/
if (self.isServer) {
   var port_ip_player = htme_ds_map_find_key(self.playermap,inst_player);
   var inst_room = ds_map_find_value(self.playerrooms,port_ip_player);
   if (is_undefined(inst_room)) inst_room = -1;
} else {
   var inst_room = room;
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
buffer_seek(self.buffer, buffer_seek_start, 0);
//Write header
buffer_write(self.buffer, buffer_s8, htme_packet.INSTANCE_VARGROUP);
//Write instance hash
buffer_write(self.buffer, buffer_string, inst_hash);
//Write player
buffer_write(self.buffer, buffer_string, inst_player);
//Write room
buffer_write(self.buffer, buffer_u16, inst_room);
//Write groupname
buffer_write(self.buffer, buffer_string, group[? "name"]);
//Write object id
buffer_write(self.buffer, buffer_u16, inst_object);
//Write stayAlive
buffer_write(self.buffer,buffer_bool, inst_stayAlive);
//Write tolerance
buffer_write(self.buffer,buffer_f32, group[? "tolerance"]);
//Write datatype
buffer_write(self.buffer,buffer_u16, group[? "datatype"]);

//Server: Sync in clientmode if local instance
if (self.isServer && inst_player != self.playerhash) {
   if (!htme_serverSyncSingleVarGroup(group,self.buffer)) {
      exit;
   }
} else {
   if (!htme_clientSyncSingleVarGroup(group,self.buffer)) {
    exit;
   }
}

/** Check type of delivery **/
if (group[? "type"] == mp_type.IMPORTANT || group[? "type"] == mp_type.SMART) {
    //Send via signed
    if (self.isServer) {
        if (is_real(target)) {
            var port_ip_player = htme_ds_map_find_key(self.playermap,inst_player);
            if (!htme_isStayAlive(inst_hash)) {
               htme_sendNewSignedPacket(self.buffer,all,port_ip_player,inst_room);
            } else {
              htme_sendNewSignedPacket(self.buffer,all,port_ip_player);
            }
        } else if (target != inst_player) {
            if (htme_serverPlayerIsInRoom(target,inst_room) || htme_isStayAlive(inst_hash)) {
                htme_sendNewSignedPacket(self.buffer,target);
            }
        }
    } else {
        htme_sendNewSignedPacket(self.buffer,noone);
    }
} else {
    //Send normally
    if (self.isServer) {
        if (is_real(target)) {
            var port_ip_player = htme_ds_map_find_key(self.playermap,inst_player);
            if (!htme_isStayAlive(inst_hash)) {
               htme_serverSendBufferToAllExcept(self.buffer,port_ip_player,inst_room);
            } else {
              htme_serverSendBufferToAllExcept(self.buffer,port_ip_player);
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
