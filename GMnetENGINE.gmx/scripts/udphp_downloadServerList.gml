///udphp_downloadServerList([limit],[sortby],[sortby_dir],[filter_data1],[filter_data2],[dfilter_ata3],[filter_data4],[filter_data5],[filter_data6],[dfilter_ata7],[filter_data8])

/*
**  Description:
**      This command is independent of clients and servers. It can be run
**      without a client or server started.
**
**      Download the list of servers from the master server.
**      global.udphp_downloadlist_refreshing will be set true.
**      It will be set false again if download is finished and 
**      global.udphp_downloadlist will contain a list of online servers then.
**      If download fails, global.udphp_downloadlist_refreshing will never reset.
**      It will fail, if the master server has the lobby disabled or is not
**      reachable.
**
**      Use the (optional) arguments to sort and filter the list.
**      Default sorting can be seen below under arguments.
**
**      Format:
**      ds_list:
**       [0...] => ds_map:
**                 [ip]    => string
**                 [data1] => string
**                 [data2] => string
**                 [data3] => string
**                 [data4] => string
**                 [data5] => string
**                 [data6] => string
**                 [data7] => string
**                 [data8] => string
**                 [createdTime] => string -> can be converted to real
**                                  unix timestamp, time the server was created.
**
**  
**  Usage:
**      udphp_downloadServerList()
**
**  Arguments:
**      ALL OPTIONAL!
**
**      limit       string/real     The number of servers to return or EMPTY STRING if ALL
**                                  servers should be returned
**      sortby      string          Field to sort the result by, this can be:
**                                  * date (filter by time created; DEFAULT)    
**                                  * data1
**                                  * data2
**                                  * data3
**                                  * data4
**                                  * data5
**                                  * data6
**                                  * data7
**                                  * data8
**      sortby_dir  string          Sort ascending ("ASC") or descending ("DESC"; DEFAULT)
**      filter_data1 string         Only list servers that match this excact string for
**                                  their first data string. Can be EMPTY STRING if you
**                                  don't want to filter
**      filter_data2 string         <See above>
**      filter_data3 string         <See above>
**      filter_data4 string         <See above>
**      filter_data5 string         <See above>
**      filter_data6 string         <See above>
**      filter_data7 string         <See above>
**      filter_data8 string         <See above>
**
**  Returns:
**      <nothing>
**
*/

var limit = "";
var sortby = "date";
var sortby_dir = "DESC";
var filter_data1 = "";
var filter_data2 = "";
var filter_data3 = "";
var filter_data4 = "";
var filter_data5 = "";
var filter_data6 = "";
var filter_data7 = "";
var filter_data8 = "";

if (argument_count > 0) {
    limit = argument[0];
}
if (argument_count > 1) {
    sortby = argument[1];
}
if (argument_count > 2) {
    sortby_dir = argument[2];
}
if (argument_count > 3) {
    filter_data1 = argument[3];
}
if (argument_count > 4) {
    filter_data2 = argument[4];
}
if (argument_count > 5) {
    filter_data3 = argument[5];
}
if (argument_count > 6) {
    filter_data4 = argument[6];
}
if (argument_count > 7) {
    filter_data5 = argument[7];
}
if (argument_count > 8) {
    filter_data6 = argument[8];
}
if (argument_count > 9) {
    filter_data7 = argument[9];
}
if (argument_count > 10) {
    filter_data8 = argument[10];
}

if (ds_exists(global.udphp_downloadlist_topmap,ds_type_map)) {
   ds_map_destroy(global.udphp_downloadlist_topmap);
}
global.udphp_downloadlist = -1;
global.udphp_downloadlist_refreshing = true;

var buffer = buffer_create(256, buffer_grow, 1);
//TCP -> Open connection
buffer_seek(buffer, buffer_seek_start, 0);
buffer_write(buffer, buffer_string, "lobby2"+chr(10));
buffer_write(buffer, buffer_string, string(filter_data1)+chr(10));
buffer_write(buffer, buffer_string, string(filter_data2)+chr(10));
buffer_write(buffer, buffer_string, string(filter_data3)+chr(10));
buffer_write(buffer, buffer_string, string(filter_data4)+chr(10));
buffer_write(buffer, buffer_string, string(filter_data5)+chr(10));
buffer_write(buffer, buffer_string, string(filter_data6)+chr(10));
buffer_write(buffer, buffer_string, string(filter_data7)+chr(10));
buffer_write(buffer, buffer_string, string(filter_data8)+chr(10));
buffer_write(buffer, buffer_string, string(sortby)+chr(10));
buffer_write(buffer, buffer_string, string(sortby_dir)+chr(10));
buffer_write(buffer, buffer_string, string(limit)+chr(10));

global.udphp_downloadServerlistSocket = network_create_socket(network_socket_tcp);
var err = network_connect_raw(global.udphp_downloadServerlistSocket,global.udphp_master, global.udphp_master_port);
if (err<0) udphp_handleerror(udphp_dbglvl.WARNING, udphp_dbgtarget.MAIN, 0, "udphp_downloadServerList - TCP Connection failed.");
//Save this socket so we know the master server speaks to us when checking incoming packets.
network_send_raw(global.udphp_downloadServerlistSocket,buffer, buffer_tell(buffer) );
udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.MAIN, 0, "Requested server list.");
buffer_delete(buffer);
