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
key = ds_map_find_first(self.localInstances);
for(var i=0; i<ds_map_size(self.localInstances); i+=1) {
    var inst_id = ds_map_find_value(self.localInstances,key);
    if (instance_exists(inst_id)) {
        htme_cleanUpInstance(inst_id);
        if wasServer 
            htme_serverRemoveBackup(key);
        with inst_id {instance_destroy();}
    }
    key = ds_map_find_next(self.localInstances, key);
}
key = ds_map_find_first(self.globalInstances);
for(var i=0; i<ds_map_size(self.globalInstances); i+=1) {
    var inst_id = ds_map_find_value(self.globalInstances,key);
    if (instance_exists(inst_id)) {
        htme_cleanUpInstance(inst_id);
        if wasServer
            htme_serverRemoveBackup(key);        
        with inst_id {instance_destroy();}
    }
    key = ds_map_find_next(self.globalInstances, key);
}
//CLEAN ALL DATA
ds_map_clear(self.localInstances);
ds_map_clear(self.globalInstances);
self.udphp_client_id = 0;
network_destroy(self.socketOrServer);
self.socketOrServer = -1;
self.server_ip = "";
self.playerhash = "";
self.server_port = 0;
if (ds_exists(self.udphp_playerlist, ds_type_map)) {ds_map_destroy(self.udphp_playerlist);}
if (ds_exists(self.playermap, ds_type_map)) {ds_map_destroy(self.playermap);}
if (ds_exists(self.kickmap, ds_type_map)) {ds_map_destroy(self.kickmap);}
if (ds_exists(self.playerrooms, ds_type_map)) {ds_map_destroy(self.playerrooms);}
if (ds_exists(self.playerlist, ds_type_list)) {ds_list_destroy(self.playerlist);}
if (ds_exists(self.grouplist, ds_type_list)) {ds_list_destroy(self.grouplist);}
if (ds_exists(self.grouplist_local, ds_type_list)) {ds_list_destroy(self.grouplist_local);}
if (ds_exists(self.globalsync, ds_type_map)) {ds_map_destroy(self.globalsync);}
if (ds_exists(self.globalsync_datatypes, ds_type_map)) {ds_map_destroy(self.globalsync_datatypes);}
if (ds_exists(self.serverTimeoutSend, ds_type_map)) {ds_map_destroy(self.serverTimeoutSend);}
if (ds_exists(self.serverTimeoutRecv, ds_type_map)) {ds_map_destroy(self.serverTimeoutRecv);}
if (ds_exists(self.signedPacketsCategories, ds_type_map)) {ds_map_destroy(self.signedPacketsCategories);}
if (ds_exists(self.serverBackup, ds_type_map)) {ds_map_destroy(self.serverBackup);}
if (ds_exists(self.signedPackets, ds_type_list)) {ds_list_destroy(self.signedPackets);}
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
}
