//TODO HEADER
self.started = false;
self.isServer = false;
self.isConnected = false;
self.socketOrServer = -1;
self.clientStopped = true;
//TODO DESTROY ALL INSTANCES
//TODO CLEAN ALL DATA
ds_map_clear(self.localInstances);
ds_map_clear(self.globalInstances);
if (ds_exists(self.chatQueues,ds_type_map))
    ds_map_destroy(self.chatQueues);
