///htme_clientConnect();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      This script sends a packet to the server every step to ask for connection, if
**      the client is not already connected.
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

if (!self.isConnected) {
    //Connect to server now!
    htme_debugger("htme_clientStart",htme_debug.DEBUG,"Connecting with server "+string(server_ip)+":"+string(server_port))
    self.client_timeout++;
    //Send a packet to the server to request connection. If this reaches the server, he will
    //add us to the list of players and send an answer.
    buffer_seek(self.buffer, buffer_seek_start, 0);
    buffer_write(self.buffer, buffer_s8, htme_packet.CLIENT_REQUESTCONNECT );
    network_send_udp( self.socketOrServer, self.server_ip, self.server_port, self.buffer, buffer_tell(self.buffer) );
    if (self.client_timeout > self.global_timeout) {
        //When the timeout was exceeded, give up and stop client
        //IF YOU WANT TO CHECK IF THE CONECTION WAS SUCCESSFUL, CHECK IF THE ENGINE IS STOPPING
        //AFTER YOU STARTED THE CLIENT! More information in the manual!
        htme_debugger("htme_clientStart",htme_debug.ERROR,"Could not connect to server!");
        htme_clientStop();
        exit;
    }
}
