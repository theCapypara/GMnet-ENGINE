///htme_initSignedPacket(buffer,target);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      USE htme_sendNewSignedPacket! This is only used internally!
**      
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      buffer    real      the buffer to send
**      target    string    ip:port
**  Returns:
**      <nothing>
**
*/

var buffer = argument0;
var target  = argument1;

// Current in buffer (if any)
// Too make sure the in buffer is not deleted
var in_buffer=noone
if is_undefined(async_load)
{
    ds_map_find_value(async_load, "buffer");
    if is_undefined(in_buffer) in_buffer=noone;
}

//Get Player Outmap
var target_outmap = ds_map_find_value(self.sPcountOUT,target);
if (is_undefined(target_outmap)) {
    target_outmap = ds_map_create();
    target_outmap[? "n"] = -1;
    ds_map_add_map(self.sPcountOUT,target,target_outmap);
}

//Get current packet id
var n = target_outmap[? "n"]+1;
//Copy and cache buffer
var cache_buffer = buffer_create(buffer_tell(buffer), buffer_fixed, 1);
buffer_copy(buffer,0,buffer_tell(buffer),cache_buffer,0);
buffer_seek(cache_buffer, buffer_seek_end, 0);

ds_map_add(target_outmap,n,cache_buffer);

//remove old entries
if (ds_map_exists(target_outmap,n-signed_buffer_cache)) 
{
    var find_old_buffer=ds_map_find_value(target_outmap,n-signed_buffer_cache);
    // Make sure the values is not the in buffer
    if in_buffer!=find_old_buffer buffer_delete(find_old_buffer);
    ds_map_delete(target_outmap,n-signed_buffer_cache);
}

target_outmap[? "n"] = n;

//Send this entry
htme_sendSingleSignedPacket(target,cache_buffer,n);
