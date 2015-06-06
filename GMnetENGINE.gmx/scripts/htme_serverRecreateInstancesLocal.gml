///htme_serverRecreateInstancesLocal();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Looks through the global instances map and creates an instance for every
**      non local instance in the same room, if it doesn't already exist
**      for safety same goes for stayalive
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

htme_debugger("htme_serverRecreateInstancesLocal",htme_debug.DEBUG,"Recreating local missing instances...");

var mapToUse = self.globalInstances;

var key= ds_map_find_first(mapToUse);
//This will loop through all global instances
for(var i=0; i<ds_map_size(mapToUse); i+=1) {
    var inst = ds_map_find_value(mapToUse,key);
    if (!instance_exists(inst)) {
        var backupEntry = ds_map_find_value(self.serverBackup,key);
        //Abort if backupEntry does not exist
        if (is_undefined(backupEntry)) {key = ds_map_find_next(mapToUse, key);continue;}
        //Skip local; Local instances should be already filtered by the statement above though.
        if (backupEntry[? "player"] == self.playerhash) {key = ds_map_find_next(mapToUse, key);continue;}
        //Check if player in same roo
        var port_ip_player = htme_ds_map_find_key(self.playermap,backupEntry[? "player"]);
        var insameroom = htme_serverPlayerIsInRoom(port_ip_player,room);
        if (!insameroom && !htme_isStayAlive(key)) {key = ds_map_find_next(mapToUse, key);continue;}
        //RECREATE
        var backupVars = backupEntry[? "backupVars"];
        self.tmp_creatingNetworkInstance = true;
        self.tmp_creatingNetworkInstanceNoGroups = true;
        self.tmp_creatingNetworkInstanceHash = key;
        inst = instance_create(-100,-100,backupEntry[? "object"]);
        self.tmp_creatingNetworkInstance = false;
        self.tmp_creatingNetworkInstanceNoGroups = false;
        ds_map_replace(self.globalInstances,key,inst);
        with inst {
            self.htme_mp_id = key;
            self.htme_mp_object = backupEntry[? "object"];
            self.htme_mp_player = backupEntry[? "player"];
            //rest get's added via mp_sync
            //...but we need to add everything from the backupEntry, which
            //is easy:
            x = backupVars[? "x"];
            y = backupVars[? "y"];
            image_alpha = backupVars[? "image_alpha"];
            image_blend = backupVars[? "image_blend"];
            image_index = backupVars[? "image_index"];
            image_speed = backupVars[? "image_speed"];
            image_xscale = backupVars[? "image_xscale"];
            image_yscale = backupVars[? "image_yscale"];
            visible = backupVars[? "visible"];
            direction =  backupVars[? "direction"];
            gravity = backupVars[? "gravity"];
            gravity_direction = backupVars[? "gravity_direction"];
            friction = backupVars[? "friction"];
            hspeed = backupVars[? "hspeed"];
            vspeed = backupVars[? "vspeed"];
            self.htme_mp_vars = ds_map_create();
            ds_map_copy(self.htme_mp_vars,backupVars);
            event_perform(ev_step,ev_step_end);
        }
    }

    key = ds_map_find_next(mapToUse, key);
}
