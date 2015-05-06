///htme_sendSignedPackets()

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      This sends all signed packets in signedPackets and removes them from the list if the
**      timeout has been reached
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

//Make sure, we are connected or server
if (!self.isServer && !(!self.isServer && self.isConnected)) exit;

//This will loop through all outgoing signed Packets
for(var i=0; i<ds_list_size(self.signedPackets); i+=1) {
    var packet = ds_list_find_value(self.signedPackets,i);
    if (is_undefined(packet) || !ds_exists(packet,ds_type_map)) {
       //That's odd
       htme_debugger("htme_sendSignedPackets",htme_debug.WARNING,"Somehow a packet that we wanted to send didn't exist.");
       ds_map_delete(self.signedPackets,i);
       i=i-1;
       continue;
    }
    var timeout = packet[? "timeout"];
    htme_sendSignedPacket(i);
    if (timeout < 0) {
        htme_debugger("htme_sendSignedPackets",htme_debug.DEBUG,"Remove signed packet "+packet[? "hash"]+" due to timeout!");
        htme_removeSignedPacket(i);
        i=i-1;
        continue;
    } else {
        packet[? "timeout"] = packet[? "timeout"]-1;
    }
}