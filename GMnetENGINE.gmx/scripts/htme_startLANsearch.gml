///htme_startLANsearch(port,[gamefilter]);

/*
**  Description:
**      Search in the LAN for servers on the port specified.
**      You can now use htme_getLANServers() to get a list of LAN servers. 
**      This list will be filled with servers over time. Run this comamnd again to empty
**      it and resend the broadcast (to refresh the list).
**
**
**      Format of each server list entry:
**      ds_list:
**       [0...] => ds_map:
**                 [ip]    => string
**                 [port]  => real
**                 [data1] => string
**                 [data2] => string
**                 [data3] => string
**                 [data4] => string
**                 [data5] => string
**                 [data6] => string
**                 [data7] => string
**                 [data8] => string
**
**  
**
**  Arguments:
**      port      r  real         The port to scan on
**      [gamefilter] string      (optional) 
**                                Only list servers that match this excact string for
**                                their first data string (the gamename).
**                                Can be EMPTY STRING if you
**                                don't want to filter
**
**  Returns:
**      <nothing>
**
*/

var port = argument[0];
var gamefilter = "";
if (argument_count > 1) {
    gamefilter = argument[1];
}

with (global.htme_object) {
    ds_list_destroy(self.lanlobby);
    self.lanlobby = ds_list_create();
    self.lanlobbyport = port;
    self.lanlobbysearch = true;
    self.lanlobbyfilter = gamefilter;
    self.lanlobbysearchserver = network_create_server(network_socket_udp,port+1,32);
}
