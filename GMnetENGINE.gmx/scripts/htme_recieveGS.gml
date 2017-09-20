///htme_recieveGS();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**      Parse a global sync update and if server: rebroadcast it
**      
**  
**  Usage:
**      <See above>
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

var num = buffer_read(in_buff, buffer_u8 );

for (var i=0;i<num;i++) {
    var name = buffer_read(in_buff, buffer_string );
    var datatype = buffer_read(in_buff, buffer_u8 );
    var value = buffer_read(in_buff, datatype );
    
    //Commit
    ds_map_replace(self.globalsync,name,value);
    ds_map_replace(self.globalsync_datatypes,name,datatype);
    
    if (self.isServer) {
       //Rebroadcast
       var player = in_ip+":"+string(in_port);
       htme_sendGS(all,name,player);
    }
}
