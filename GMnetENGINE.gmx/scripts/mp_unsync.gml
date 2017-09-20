///mp_unsync()

/*
**  Description:
**      Removes an instance from the engine and
**        * if not local: destroys it
**        * if local: informs server which then informs all players.
**                    Does NOT destroy local instances! You have to do that
**                    yourself when calling this manually!
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      <nothing>
**
**  Returns:
**      <none>
**
*/

htme_debugger("mp_unsync",htme_debug.DEBUG,"Unsyncing "+self.htme_mp_id+"!");

var isLocal = false;
if (self.htme_mp_player == global.htme_object.playerhash) isLocal = true;

if (!isLocal) {
   htme_debugger("mp_unsync",htme_debug.WARNING,"Destroyed non-local instance "+self.htme_mp_id+" on mp_unsync!");
   instance_destroy();
} else {
  var hash = self.htme_mp_id;
     //Remove from local and global list
  ds_map_delete(global.htme_object.localInstances,hash);
  ds_map_delete(global.htme_object.globalInstances,hash);
  htme_cleanUpInstance(self.id);
  if (!global.htme_object.isServer) {
     //If we are not server: tell server using a signed packet
     htme_debugger("mp_unsync",htme_debug.DEBUG,"Announcing unsynced instance to server");
     with global.htme_object {htme_clientBroadcastUnsync(hash)};
  } else {
    //Use broadcaster script
    //This also needs to be called in serverNetworking when recieving a client
    //broadcast
     htme_debugger("mp_unsync",htme_debug.DEBUG,"Announcing unsynced instance to all clients");
     with global.htme_object {htme_serverRemoveBackup(hash);htme_serverBroadcastUnsync(hash)};
  }
}
