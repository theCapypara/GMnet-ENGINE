///htme_sendSignedPacket(i);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Sends a previously created SignedPacket, this get's done for each signed packet in the
**      step events of client and server and upon creation of the packet
**      
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      i    real    index of the packet as stored in signedPackets
**
**  Returns:
**      <nothing>
**
*/

var i = argument0;
htme_debugger("htme_sendSignedPacket",htme_debug.DEBUG,"Sending signed packet with index "+string(i));
    
var packet = ds_list_find_value(self.signedPackets,i);
if (is_undefined(packet)) {
    htme_debugger("htme_sendSignedPacket",htme_debug.WARNING,"Tried sending signed packet nonexisting packet with index "+string(i));
    exit;
}

var target = packet[? "target"];
var ip = htme_playerMapIP(target);
var port = htme_playerMapPort(target);
var cmd_list = packet[? "cmd_list"];

htme_fillSignedPacketBuffer(self.buffer,cmd_list);

//Send!
network_send_udp( self.socketOrServer, ip, port, self.buffer, buffer_tell(self.buffer) );
