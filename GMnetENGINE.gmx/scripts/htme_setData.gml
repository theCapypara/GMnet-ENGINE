///htme_setData(id(2-8),string)

/*
**  Description:
**      A server must be running!!
**      Set data that can be used by the lobby (GMnet PUNCH) and be retrieved by 
**      connected clients.
**      The main purpose of this is to set general metadata for the server
**      which can be used for lobbys.
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      id          real    The id of the data string (2-8). 
**                          1 does also work but will set the game name 
**                          (see htme_init and htme_setGamename)
**      string     string   The string to set the data to.
**
**  Returns:
**      <nothing>
**
*/

with (global.htme_object) {

    switch argument0 {
        case 1:
             self.gamename = argument1;
        break;
        case 2:
             self.server_data2 = argument1;
        break;
        case 3:
             self.server_data3 = argument1;
        break;
        case 4:
             self.server_data4 = argument1;
        break;
        case 5:
             self.server_data5 = argument1;
        break;
        case 6:
             self.server_data6 = argument1;
        break;
        case 7:
             self.server_data7 = argument1;
        break;
        case 8:
             self.server_data8 = argument1;
        break;
    }
    
    //Sync with GMnet PUNCH
    if (self.use_udphp) {
        script_execute(asset_get_index("udphp_serverSetData"),argument0,argument1);
    }

}
