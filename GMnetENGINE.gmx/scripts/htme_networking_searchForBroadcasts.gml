///htme_networking_searchForBroadcasts();

/*
**  Description:
**      This does NOT need to be run with the htme object!
**
**      This should be called in the networking event of your LAN lobby.
**
**      It listens for incoming LAN servers.
**      Warning: May conflict with htme_networking. Do not use while htme server/client
**      is active!
**
**  Usage:
**      <See above>
**
**  Arguments:
**      <None>
**
**  Returns:
**      <Nothing>
**
*/
with (global.htme_object) {
    if(!self.lanlobbysearch) {exit;}
    //Set up some local variables.
    buffer_seek(buffer, buffer_seek_start, 0);
    var in_ip = ds_map_find_value(async_load, "ip");
    var in_buff = ds_map_find_value(async_load, "buffer");
    var in_id = ds_map_find_value(async_load, "id");
    var in_port = ds_map_find_value(async_load, "port");
    
    //Read command
    code = buffer_read(in_buff, buffer_s8 );
    switch code {
        case htme_packet.SERVER_BROADCAST:
            var data1 = buffer_read(in_buff, buffer_string );
            if (self.lanlobbyfilter != "") {
                if (self.lanlobbyfilter != data1)
                    exit;
            }
            var map = ds_map_create();
            var serverlist = self.lanlobby;
            map[? "ip"] = in_ip;
            map[? "port"] = self.lanlobbyport;
            map[? "data1"] = data1;
            map[? "data2"] = buffer_read(in_buff, buffer_string );
            map[? "data3"] = buffer_read(in_buff, buffer_string );
            map[? "data4"] = buffer_read(in_buff, buffer_string );
            map[? "data5"] = buffer_read(in_buff, buffer_string );
            map[? "data6"] = buffer_read(in_buff, buffer_string );
            map[? "data7"] = buffer_read(in_buff, buffer_string );
            map[? "data8"] = buffer_read(in_buff, buffer_string );
            //Prevent duplicate entries
            for (var i = 0;i<ds_list_size(serverlist);i++) {
                var valmap = ds_list_find_value(serverlist,i)
                if (valmap[? "ip"] == map[? "ip"]) {
                    ds_list_replace(serverlist,i,map);
                    exit;
                }
            }
            ds_list_add(serverlist,map);
        break;
    }
}
