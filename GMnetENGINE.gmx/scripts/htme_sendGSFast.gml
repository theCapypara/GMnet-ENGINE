///htme_sendGSFast(target,variable,[exclude]);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**      Broadcast a global sync update to other clients or the server without using signed packets.
**      
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      target    mixed     STRING [SERVER ONLY]:
**                          the connection details of the client as "ip:port" like they are
**                          stored as keys in the playermap of the server.
**                          OR [REAL/CONSTANTS]:
**                          all [SERVER ONLY] -> Send to all connected players
**                          noone [CLIENT ONLY] -> Send to server
**      variable  mixed     STRING: 
**                          the name of the variable to update
**                          OR [REAL/CONSTANTS]:
**                          all [SERVER ONLY] -> Send all variables to this client, his
**                                               changes may all be overwritten!
**      [exclude] string    (optional)    
**                          When using all as target this can be used to exclude a single
**                          player; all and noone are not allowed!
**                          Can be empty string for none.
**
**  Returns:
**      <nothing>
**
*/

var target = argument[0];
var variable = argument[1];
var exclude = "";
if (argument_count > 2) {
    exclude = argument[2];
}

buffer_seek(self.buffer, buffer_seek_start, 0);
//Write header
buffer_write(self.buffer, buffer_s8, htme_packet.GLOBALSYNC);
var varval, vardt;
if (is_string(variable)) {
    //SYNC SPECIFIC
    var varname= variable;
    varval = ds_map_find_value(self.globalsync,varname);
    vardt = ds_map_find_value(self.globalsync_datatypes,varname);
    //Write number of variables
    buffer_write(self.buffer, buffer_u8,1);
    //Write variable name
    buffer_write(self.buffer, buffer_string,varname);
    //Write buffer type
    buffer_write(self.buffer, buffer_u8,vardt);
    //Write variable
    buffer_write(self.buffer, vardt,varval);
} else if (variable == all) {
    //SYNC ALL
    var varname= ds_map_find_first(self.globalsync);
    //Write number of variables
    buffer_write(self.buffer, buffer_u8,ds_map_size(self.globalsync));
    for(var i=0; i<ds_map_size(self.globalsync); i+=1) {
        varval = ds_map_find_value(self.globalsync,varname);
        vardt = ds_map_find_value(self.globalsync_datatypes,varname);
        //Write variable name
        buffer_write(self.buffer, buffer_string,varname);
        //Write buffer type
        buffer_write(self.buffer, buffer_u8,vardt);
        //Write variable
        buffer_write(self.buffer, vardt,varval);
        varname = ds_map_find_next(self.globalsync, varname);
    }
}

with (global.htme_object) {
    if (is_string(target)) {
       //Single target
       htme_debugger("htme_sendGSFast",htme_debug.DEBUG,"Global Sync: Sending to "+target);
       var ip = htme_playerMapIP(target);
       var port = htme_playerMapPort(target);
       network_send_udp( self.socketOrServer, ip, port, self.buffer, buffer_tell(self.buffer) );
    } else if (target == noone) {
        if (!self.isServer) {
            htme_debugger("htme_sendGSFast",htme_debug.DEBUG,"Global Sync: Sending to server");
            network_send_udp( self.socketOrServer, self.server_ip, self.server_port, self.buffer, buffer_tell(self.buffer) );
        }
    } else if (target == all) {
        //Safety first: is Server?
        if (self.isServer) {
            htme_debugger("htme_sendGSFast",htme_debug.DEBUG,"Global Sync: Sending to all players");
            htme_serverSendBufferToAllExcept(self.buffer,exclude);
        }
    }
}
