///htme_clientCheckConnectionNetworking();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Checks if a ping packet was received and resets the counter if it was waiting for
**      a ping.
**  
**  Usage:
**      <see above>
**
**  Arguments:
**      <none>
**
**  Returns:
**      <nothing>
**
*/

if (!self.isConnected) {exit;}

//Set up some local variables.
var in_ip = ds_map_find_value(async_load, "ip");
var in_buff = ds_map_find_value(async_load, "buffer");
var in_id = ds_map_find_value(async_load, "id");
var in_port = ds_map_find_value(async_load, "port");
buffer_seek(in_buff, buffer_seek_start, 0);

//Check that the packet is from the server
if (in_ip == self.server_ip) {
    //Read command
    switch buffer_read(in_buff, buffer_s8 ) {
        case htme_packet.PING:
            //Got a ping! Reset if our counter is negative
            self.clientTimeoutRecv = self.global_timeout;
            htme_debugger("htme_clientCheckConnectionNetworking",htme_debug.DEBUG,"Ping recieved.");
        break;
    }
}
