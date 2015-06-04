///htme_fillSignedPacketBuffer(buffer,cmd_list);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      This fills a buffer with the instructions in a cmd_list. More information in
**      htme_createSignedPacket
**      
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      buffer      buffer      the outgoing buffer
**      cmd_list    ds_list     the list of commands as described in htme_createSignedPacket
**
**  Returns:
**      <nothing>
**
*/
htme_debugger("htme_signedPacketFillBuffer",htme_debug.DEBUG,"Filling a buffer with a cmd_list");

var buffer = argument0;
var cmd_list = argument1;

//Reset buffer
buffer_seek(buffer, buffer_seek_start, 0);

//Loop through list
for (var i=0;i<ds_list_size(cmd_list);i+=2) {
    var type = ds_list_find_value(cmd_list,i);
    var content = ds_list_find_value(cmd_list,i+1);
    if (is_undefined(content)) {
        htme_debugger("htme_signedPacketFillBuffer",htme_debug.ERROR,"TRIED TO SEND UNDEFINED CONTENT IN A BUFFER!");
        htme_debugger("htme_signedPacketFillBuffer",htme_debug.ERROR,"THIS MAY CRASH THE GAME, BUT THERE IS NO WAY TO CONTINUE! PLEASE REPORT!");
        if (self.isServer) {
           htme_serverStop();
        } else {
           htme_clientStop();
        }
        exit;
    }
    buffer_write(buffer, type, content);
}
