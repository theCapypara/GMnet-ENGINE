///udphp_serverSetData(n,string)

/*
**  Description:
**      This will change the data string with the number n (n=1-8) of the server.
**      Data strings are used in the lobby and can also be retrieved by clients
**      when connected. They store the game name/version, server name, and
**      anything else you want.
**      You should use this command after udphp_createServer.
**      If you want to change these later, after the server is already connected
**      to the master server, use this script to update it, and send the
**      changes to the master server with udphp_serverCommitData
**      
**      WARNING!!!!!
**      The data strings MUST NOT contain char(10) (newline line feed)!
**  Usage:
**      udphp_serverSetData(n,string)
**
**  Arguments:
**      n       int                    Number of the data string (1-8)
**                                     1 should be used by a game name/
**                                     version string
**      string  string                 The string that the data string should
**                                     be replaced with
**
**  Returns:
**      <nothing>
**
*/

/// CHECK IF SERVER IS RUNNING (we can use any server-releated variable for that; we assume they don't get changed from outside)
if (global.udphp_server_counter == -1) {
    udphp_handleerror(udphp_dbglvl.WARNING, udphp_dbgtarget.SERVER, 0, "Server was not started.");
    exit;
}

switch argument0 {
    case 1:
         global.udphp_server_data1 = argument1;
    break;
    case 2:
         global.udphp_server_data2 = argument1;
    break;
    case 3:
         global.udphp_server_data3 = argument1;
    break;
    case 4:
         global.udphp_server_data4 = argument1;
    break;
    case 5:
         global.udphp_server_data5 = argument1;
    break;
    case 6:
         global.udphp_server_data6 = argument1;
    break;
    case 7:
         global.udphp_server_data7 = argument1;
    break;
    case 8:
         global.udphp_server_data8 = argument1;
    break;
}
