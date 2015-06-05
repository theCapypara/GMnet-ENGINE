///htme_sendSingleSignedPacket(target,buffer,n);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Sends a previously created SignedPacket
**      
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      target string  ip:port
**      buffer real    The buffer to send
**      n      real    Number of this packet
**
**  Returns:
**      <nothing>
**
*/

var target = argument0;
var send_buffer = argument1;

buffer_seek(self.buffer, buffer_seek_start, 0);
buffer_write(self.buffer, buffer_s8, htme_packet.SIGNEDPACKET_NEW);
buffer_write(self.buffer, buffer_u32, n);
buffer_copy(send_buffer,0,buffer_tell(send_buffer),self.buffer,buffer_tell(self.buffer));


htme_debugger("htme_sendSingleSignedPacket",htme_debug.DEBUG,"Sending signed packet");
network_send_udp( self.socketOrServer, ip, port, self.buffer, buffer_tell(self.buffer));
