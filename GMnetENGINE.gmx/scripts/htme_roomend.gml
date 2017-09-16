///htme_roomend()

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      This handles local and global instance destruction on room change.
**      This script does the following:
**      (1) It unregisters all global instances from the engine, that are not
**          local instances that are not stayalive
**      (2) It destroyss all PERSISTENT global instances that are not local
**          instances and are not stayAlive.
**      (3) It unregisters all not persistent local instances and syncs them with server
**      (Global and local non persistent instances will get destroyed auto-
**      matically by GM.)
**
**      The server picks up the room change in htme_roomstart
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

if (!self.started || !self.isConnected) exit;

var new_insthash = undefined;

htme_debugger("htme_roomend",htme_debug.DEBUG,"ROOMEND triggered!");

var mapToUse=ds_map_create();
ds_map_copy(mapToUse,self.globalInstances);

var insthash=ds_map_find_first(mapToUse);

//This will loop through all global instances
for(var i=0; i<ds_map_size(mapToUse); i+=1) {
    var instid = ds_map_find_value(mapToUse,insthash);
    if (!is_undefined(instid)) {
        if (!instance_exists(instid)) {insthash = ds_map_find_next(mapToUse, insthash);continue;}
        //Do nothing if stay alive
        if (htme_isStayAlive(insthash)) {insthash = ds_map_find_next(mapToUse, insthash);continue;}
        var isLocal = false;
        if ((instid).htme_mp_player == self.playerhash) isLocal = true;
        if (!isLocal) {
           /* (1) */
           htme_debugger("htme_roomend",htme_debug.DEBUG,"Unregistered a global instance "+insthash+"!");
           if (!self.isServer) {
              ds_map_delete(self.globalInstances,insthash);
           }
            /* (2) */ 
            // Handle persistent
            if ((instid).persistent) {
               htme_debugger("htme_roomend",htme_debug.INFO,"Destroyed a persistent global instance "+insthash+"!");
               // On server do a simple clean but on client do a full sweep
               if (self.isServer) {
                   with instid {
                     htme_clean_mp_sync();
                     instance_destroy();
                   }
               } else {
                   htme_cleanUpInstance(instid);
                   with instid {
                     instance_destroy();
                   }              
               }
            } else {
               // Handle non persistent
               htme_debugger("htme_roomend",htme_debug.INFO,"Destroyed a global instance "+insthash+"!");
               // On server do a simple clean but on client do a full sweep
               if (self.isServer) {
                   with instid {
                     htme_clean_mp_sync();
                     instance_destroy();
                   }
               } else {
                   htme_cleanUpInstance(instid);
                   with instid {
                     instance_destroy();
                   }              
               }                
            }
        } else if (!(instid).persistent) {
           htme_debugger("htme_roomend",htme_debug.DEBUG,"Unregistered a local instance "+insthash+"!");
           with (instid) {mp_unsync();}
        }
    }
    else {
        htme_debugger("htme_roomend",htme_debug.WARNING,"Undefined found in globalInstances");
    }
    // Get next
    insthash = ds_map_find_next(mapToUse, insthash);
}

htme_forceSyncLocalInstances(self.playerhash);

// Clean
ds_map_destroy(mapToUse);