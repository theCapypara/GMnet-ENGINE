///htme_clientConnect(server_ip,server_port);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      This script waits for the server packet that tells the client it is conncted.
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

if (self.isConnected) {exit;}

//Set up some local variables.
var in_ip = ds_map_find_value(async_load, "ip");
var in_buff = ds_map_find_value(async_load, "buffer");
var in_id = ds_map_find_value(async_load, "id");
var in_port = ds_map_find_value(async_load, "port");
buffer_seek(in_buff, buffer_seek_start, 0);

//SCENARIO: Client that is not yet on the players list connected.
//For some akward reasons, in_ip is empty when the server contacts the client, we are
//assuming only the server knows this endpoint.

//Check that the master server didn't send us a packet!
if (!self.use_udphp || (in_ip != self.udphp_master_ip)) {
    //Read command
    switch buffer_read(in_buff, buffer_s8 ) {
        case htme_packet.SERVER_CONREQACCEPT:
            //Connected! Yay!
            //We are recieving our player hash with every packet, so we
            //don't need to do get that here, 
            //especially since when using GMnet PUNCH, this can't be done yet anyway
            //Mark engine as conncted
            self.isConnected = true;
            htme_debugger("htme_clientConnectNetworking",htme_debug.INFO,"CONNECTED TO SERVER!");
            htme_roomstart();
        break;
    }
}
