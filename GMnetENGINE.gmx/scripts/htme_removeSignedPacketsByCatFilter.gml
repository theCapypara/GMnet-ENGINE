///htme_removeSignedPacketsByCatFilter(beginning);

/*
**  Description:
**      This removes all signed packets which category starts with {begining}
**      
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      beginning  string       the beginning of the name of the category
**
**  Returns:
**      <nothing>
**
*/

var beginning = argument0;

//This will loop through all outgoing signed Packets
for(var i=0; i<ds_list_size(self.signedPackets); i+=1) {
    var packet = ds_list_find_value(self.signedPackets,i);
    if (string_pos(beginning, packet[? "cat"]) == 1) {
       htme_removeSignedPacket(i);
    }
}