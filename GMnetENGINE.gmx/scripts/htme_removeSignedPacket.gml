///htme_removeSignedPacket(i);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Removes a packet from signedPackets
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      i   real  index of the packet as stored in signedPackets
**
**  Returns:
**      <Nothing>
**
*/

var i = argument0;

htme_debugger("htme_removeSignedPacket",htme_debug.DEBUG,"Removing signed packet "+string(i)+" from the list of outgoing packets");
var packet = ds_list_find_value(self.signedPackets,i);
if (!is_undefined(packet)) {
    var cat = packet[? "cat"]
    ds_list_destroy(packet[? "cmd_list"]);
    ds_map_destroy(packet);
    ds_list_delete(self.signedPackets,i);
    ds_map_delete(self.signedPacketsCategories,cat)
    //Also remove from map
}