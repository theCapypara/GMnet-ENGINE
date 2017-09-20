///htme_serverCheckConnections();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Waits for incoming pings of the clients
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

//Set up some local variables.
var in_ip = ds_map_find_value(async_load, "ip");
var in_buff = ds_map_find_value(async_load, "buffer");
var in_id = ds_map_find_value(async_load, "id");
var in_port = ds_map_find_value(async_load, "port");
buffer_seek(in_buff, buffer_seek_start, 0);

var player = ds_map_find_value(self.playermap,in_ip+":"+string(in_port));

//Check that the packet is from a valid client
if (!is_undefined(player)) {
    //Read command
    switch buffer_read(in_buff, buffer_s8 ) {
        case htme_packet.PING:
            //Got a ping! Reset if our counter is negative
            var timeoutRecv = ds_map_find_value(self.serverTimeoutRecv,in_ip+":"+string(in_port));
            if (is_undefined(timeoutRecv)) {
                ds_map_add(self.serverTimeoutRecv,in_ip+":"+string(in_port),self.global_timeout);
            } else {
                ds_map_replace(self.serverTimeoutRecv,in_ip+":"+string(in_port), self.global_timeout);
            }
            htme_debugger("htme_serverCheckConnectionsNetworking",htme_debug.DEBUG,"Ping recieved from"+in_ip+":"+string(in_port)+".");
        break;
    }
}
