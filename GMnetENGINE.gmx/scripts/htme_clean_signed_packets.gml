/// htme_clean_signed_packets(client_ip_port);
/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Cleans the players signed packet buffers and ds maps
**  
**  Usage:
**      ip:port     string      ip:port combination as stored as key in the player map.
**                              or "" to clean all
**
**  Arguments:
**      <none>
**
**  Returns:
**      <nothing>
**
*/

// Current in buffer (if any)
// Too make sure the in buffer is not deleted
var in_buffer=noone
if is_undefined(async_load)
{
    ds_map_find_value(async_load, "buffer");
    if is_undefined(in_buffer) in_buffer=noone;
}

// Check if clean specific target
if argument0!="" {
    // Clean target sPcountOUT buffers
    var target_outmap = ds_map_find_value(self.sPcountOUT,argument0);
    if (!is_undefined(target_outmap)) {
        if ds_exists(target_outmap, ds_type_map) 
        {
            // Loop again until complete empty
            while (!ds_map_empty(target_outmap))
            {
                // Delete buffer
                var the_key=ds_map_find_first(target_outmap);
                buffer_index=ds_map_find_value(target_outmap,the_key);
                if !is_undefined(buffer_index) 
                {
                    if in_buffer!=buffer_index buffer_delete(buffer_index);
                }
                ds_map_delete(target_outmap,the_key);
            }
            // Destroy map itself
            ds_map_destroy(target_outmap);
        }
    }
    // Delete outmap ref
    ds_map_delete(self.sPcountOUT,argument0);
    
    // Clean target sPcountIN ds_priority and buffers
    var target_inmap = ds_map_find_value(self.sPcountIN,argument0);
    if (!is_undefined(target_inmap)) {
        if ds_exists(target_inmap, ds_type_map) {
            // Get ds_priority
            var target_ds_priority=target_inmap[? "buffs"];
            if !is_undefined(target_ds_priority)
            {  
                // This will loop through all buffers in target_ds_priority
                while !ds_priority_empty(target_ds_priority)
                {
                    // Delete buffer
                    var buffer_index=ds_priority_delete_min(target_ds_priority);
                    if !is_undefined(buffer_index) 
                    {
                        if in_buffer!=buffer_index buffer_delete(buffer_index);
                    }
                }
                // Destroy ds priority
                ds_priority_destroy(target_ds_priority);
            }
            // Destroy map itself
            ds_map_destroy(target_inmap);
        }
    }
    // Delete inmap ref
    ds_map_delete(self.sPcountIN,argument0);
} else {
    // Clean all sPcountOUT buffers
    var key=ds_map_find_first(self.sPcountOUT);
    for(var ii=0; ii<ds_map_size(self.sPcountOUT); ii+=1) {
        var target_outmap = ds_map_find_value(self.sPcountOUT,key);
        if (!is_undefined(target_outmap)) {
            if ds_exists(target_outmap, ds_type_map) 
            {
                // Loop again until complete empty
                while (!ds_map_empty(target_outmap))
                {
                    // Delete buffer
                    var the_key=ds_map_find_first(target_outmap);
                    buffer_index=ds_map_find_value(target_outmap,the_key);
                    if !is_undefined(buffer_index) 
                    {
                        if in_buffer!=buffer_index buffer_delete(buffer_index);
                    }
                    ds_map_delete(target_outmap,the_key);
                }
                // Destroy map itself
                ds_map_destroy(target_outmap);
            }
        }
        // Delete outmap ref
        ds_map_delete(self.sPcountOUT,key);
        // Get next key in map
        key = ds_map_find_next(self.sPcountOUT, key);
    }
    
    // Clean all sPcountIN ds_priority and buffers
    key=ds_map_find_first(self.sPcountIN);
    for(var ii=0; ii<ds_map_size(self.sPcountIN); ii+=1) {    
        var target_inmap = ds_map_find_value(self.sPcountIN,key);
        if (!is_undefined(target_inmap)) {
            if ds_exists(target_inmap, ds_type_map) {
                // Get ds_priority
                var target_ds_priority=target_inmap[? "buffs"];
                if !is_undefined(target_ds_priority)
                {  
                    // This will loop through all buffers in target_ds_priority
                    while !ds_priority_empty(target_ds_priority)
                    {
                        // Delete buffer
                        var buffer_index=ds_priority_delete_min(target_ds_priority);
                        if !is_undefined(buffer_index) 
                        {
                            if in_buffer!=buffer_index buffer_delete(buffer_index);
                        }
                    }                
                    // Destroy ds priority
                    ds_priority_destroy(target_ds_priority);
                }
                // Destroy map itself
                ds_map_destroy(target_inmap);
            }
        }
        // Delete inmap ref
        ds_map_delete(self.sPcountIN,key);
        // Get next key in map
        key = ds_map_find_next(self.sPcountIN, key);        
    } 
}
