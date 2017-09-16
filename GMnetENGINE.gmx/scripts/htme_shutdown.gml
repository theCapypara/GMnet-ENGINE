///htme_shutdown();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Shuts down GMnet CORE with no explanation or cleaning.
**      
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      <none>
**
**  Returns:
**      <nothing>
**
*/

self.started = false;
var wasServer=self.isServer;
self.isServer = false;
self.isConnected = false;
self.clientStopped = true;
var key;
// DESTROY ALL INSTANCES
if ds_exists(self.localInstances,ds_type_map) {
    key = ds_map_find_first(self.localInstances);
    for(var i=0; i<ds_map_size(self.localInstances); i+=1) {
        var inst_id = ds_map_find_value(self.localInstances,key);
        if (instance_exists(inst_id)) {
            htme_cleanUpInstance(inst_id);
            if wasServer 
                htme_serverRemoveBackup(key);
            with inst_id {instance_destroy();}
        } else if wasServer {
            htme_serverRemoveBackup(key);
        }
        key = ds_map_find_next(self.localInstances, key);
    }
    ds_map_clear(self.localInstances);    
}
if ds_exists(self.globalInstances,ds_type_map) {
    key = ds_map_find_first(self.globalInstances);
    for(var i=0; i<ds_map_size(self.globalInstances); i+=1) {
        var inst_id = ds_map_find_value(self.globalInstances,key);
        if (instance_exists(inst_id)) {
            htme_cleanUpInstance(inst_id);
            if wasServer
                htme_serverRemoveBackup(key);        
            with inst_id {instance_destroy();}
        } else if wasServer {
            htme_serverRemoveBackup(key);
        }
        key = ds_map_find_next(self.globalInstances, key);
    }
    ds_map_clear(self.globalInstances);    
}
//CLEAN ALL DATA
if self.socketOrServer>-1 {
    network_destroy(self.socketOrServer);
    self.socketOrServer=-1;
}
self.socketOrServer = -1;
self.server_ip = "";
self.playerhash = "";
self.server_port = 0;
if (ds_exists(self.udphp_playerlist, ds_type_list)) {ds_list_destroy(self.udphp_playerlist); self.udphp_playerlist=-1;}
if (ds_exists(self.playermap, ds_type_map)) {ds_map_destroy(self.playermap); self.playermap=-1;}
if (ds_exists(self.kickmap, ds_type_map)) {ds_map_destroy(self.kickmap); self.kickmap=-1;}
if (ds_exists(self.playerrooms, ds_type_map)) {ds_map_destroy(self.playerrooms); self.playerrooms=-1;}
if (ds_exists(self.playerlist, ds_type_list)) {ds_list_destroy(self.playerlist); self.playerlist=-1;}
if (ds_exists(self.grouplist, ds_type_list)) {ds_list_destroy(self.grouplist); self.grouplist=-1;}
if (ds_exists(self.grouplist_local, ds_type_list)) {ds_list_destroy(self.grouplist_local); self.grouplist_local=-1;}
if (ds_exists(self.globalsync, ds_type_map)) {ds_map_destroy(self.globalsync); self.globalsync=-1;}
if (ds_exists(self.globalsync_datatypes, ds_type_map)) {ds_map_destroy(self.globalsync_datatypes); self.globalsync_datatypes=-1;}
if (ds_exists(self.serverTimeoutSend, ds_type_map)) {ds_map_destroy(self.serverTimeoutSend); self.serverTimeoutSend=-1;}
if (ds_exists(self.serverTimeoutRecv, ds_type_map)) {ds_map_destroy(self.serverTimeoutRecv); self.serverTimeoutRecv=-1;}
if (ds_exists(self.signedPacketsCategories, ds_type_map)) {ds_map_destroy(self.signedPacketsCategories); self.signedPacketsCategories=-1;}
if (ds_exists(self.serverBackup, ds_type_map)) {ds_map_destroy(self.serverBackup); self.serverBackup=-1;}
if (ds_exists(self.signedPackets, ds_type_list)) {ds_list_destroy(self.signedPackets); self.signedPackets=-1;}
if (ds_exists(self.lanlobby, ds_type_list)) {
    // Clean list from ds maps
    for (var i=0; i<ds_list_size(self.lanlobby); i+=1)
    {
        if ds_exists(self.lanlobby[| i],ds_type_map) {
            ds_map_destroy(self.lanlobby[| i]);
        }
    }
    ds_list_destroy(self.lanlobby);
    self.lanlobby=-1;
}

htme_clean_signed_packets("");
ds_map_destroy(self.sPcountOUT);
self.sPcountOUT = ds_map_create();
ds_map_destroy(self.sPcountIN);
self.sPcountIN = ds_map_create();
if (ds_exists(self.chatQueues,ds_type_map)) {
    key = ds_map_find_first(self.chatQueues);
    for(var i=0; i<ds_map_size(self.chatQueues); i+=1) {
        var chat_queue = ds_map_find_value(self.chatQueues,key);
        if (ds_exists(chat_queue,ds_type_queue)) {
            ds_queue_destroy(chat_queue);
        }
        key = ds_map_find_next(self.chatQueues, key);
    }    
    ds_map_destroy(self.chatQueues);
    self.chatQueues=-1;
}