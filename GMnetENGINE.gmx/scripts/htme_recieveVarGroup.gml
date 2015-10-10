///htme_recieveVarGroup();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Applies the content of a variable group package to an instance.
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      <undocumented>
**
**  Returns:
**      instance
**
*/

var in_ip = ds_map_find_value(async_load, "ip");
var in_buff = ds_map_find_value(async_load, "buffer");
var in_id = ds_map_find_value(async_load, "id");
var in_port = ds_map_find_value(async_load, "port");


var instancehash = buffer_read(in_buff,buffer_string);
var playerhash = buffer_read(in_buff,buffer_string);
var inst_room = buffer_read(in_buff,buffer_u16);
var groupname = buffer_read(in_buff,buffer_string);
var object_id = buffer_read(in_buff,buffer_u16);
var inst_stayAlive = buffer_read(in_buff,buffer_bool);
var instance = ds_map_find_value(self.globalInstances,instancehash);
var tolerance = buffer_read(in_buff,buffer_f32);
var datatype = buffer_read(in_buff,buffer_u16);

//Check if we actually know who we are
if (!self.isServer && self.playerhash == "") {
    htme_debugger("htme_recieveVarGroup",htme_debug.INFO,"Recieved vargroup but we are not continuing: We don't have a playerhash yet.");    
    exit;
}

//If we are client: Check that room is the same we are in OR instance is stayAlive
if (!self.isServer && inst_room != room && !inst_stayAlive) {
    htme_debugger("htme_recieveVarGroup",htme_debug.INFO,"Recieved vargroup but this instance is not in our room (and not stayAlive).");    
    exit;
}

//Check if player is in playerlist real quick
if (ds_list_find_index(self.playerlist,playerhash) == -1) {
   ds_list_add(self.playerlist,playerhash);
}

if ((is_undefined(instance) || !instance_exists(instance))) {
    //Server: Check if in same room or stay alive
    if (self.isServer) {
        var port_ip_player = htme_ds_map_find_key(self.playermap,playerhash);
        var insameroom = htme_serverPlayerIsInRoom(port_ip_player,room);
        //When on server, we have to create this instance even when not in same
        //room, if we are not in same room.
        var backupEntry = ds_map_find_value(self.serverBackup,instancehash);
        var backupCheck = is_undefined(backupEntry);
        //This removes the instance again in htme_serverRecieveVarGroup
        if (backupCheck && !(insameroom || inst_stayAlive)) self.tmp_instanceForceCreated = true;
    } else {
      var insameroom = true;
      var backupCheck = true;
    }
    if (insameroom || inst_stayAlive || backupCheck) {
        htme_debugger("htme_recieveVarGroup",htme_debug.DEBUG,"Got a new instance for "+instancehash+". Creating:");
        //Create instance and entry
        self.tmp_creatingNetworkInstance = true;
        //Do not create vargroups if simply changing room
        if (self.isServer && !backupCheck) {
           self.tmp_creatingNetworkInstanceNoGroups = true;
        }
        self.tmp_creatingNetworkInstanceHash = instancehash;
        instance = instance_create(-100,-100,object_id);
        self.tmp_creatingNetworkInstance = false;
        self.tmp_creatingNetworkInstanceNoGroups = false;
        ds_map_replace(self.globalInstances,instancehash,instance);
        with instance {
            self.htme_mp_id = instancehash;
            self.htme_mp_object = object_id;
            self.htme_mp_player = playerhash;
            //rest get's added via mp_sync
        }
    }
}

if (self.isServer) {
   htme_serverRecieveVarGroup(instancehash,playerhash,object_id,inst_stayAlive,instance,tolerance,datatype,groupname,inst_room);
} else {
   htme_clientRecieveVarGroup(instancehash,playerhash,object_id,instance,tolerance,datatype);
}
