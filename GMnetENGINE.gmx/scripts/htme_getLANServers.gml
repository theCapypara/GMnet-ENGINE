///htme_getLANServers();

/*
**  Description:
**      Return the list of servers in LAN.
**      Use htme_startLANsearch to start searching. This list will fill over time after
**      running that command.
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
**      <none>
**
**  Returns:
**      a ds_list containing all currently found servers.
**
*/

return global.htme_object.lanlobby;
