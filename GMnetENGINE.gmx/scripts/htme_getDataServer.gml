///htme_getDataServer(id(2-8))

/*
**  Description:
**      A server must be running!!
**      Returns a data string, previously set by htme_setData.
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      id          real    The id of the data string (2-8). 
**                          1 does also work but will get the game name 
**                          (see htme_init and htme_getGamename)
**
**  Returns:
**      <nothing>
**
*/

with (global.htme_object) {

    switch argument0 {
        case 1:
             return self.gamename;
        break;
        case 2:
             return self.server_data2;
        break;
        case 3:
             return self.server_data3;
        break;
        case 4:
             return self.server_data4;
        break;
        case 5:
             return self.server_data5;
        break;
        case 6:
             return self.server_data6;
        break;
        case 7:
             return self.server_data7;
        break;
        case 8:
             return self.server_data8;
        break;
    }
    
}
