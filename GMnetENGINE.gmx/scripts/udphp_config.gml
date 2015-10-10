///udphp_config(master_ip,master_port,reconnect_intv,timeouts,debug,silent)

/*
**  Description:
**      This will load all global variables that are required by server and clients
**      and is used to define things like master server ip and port.
**  
**  Usage:
**      udphp_config(master_ip,master_port,reconnect_intv,timeouts,debug,silent)
**
**  Arguments:
**      master_ip         string    IP of the master server
**      master_port       real      Port on which the master server software listens.
**      reconnect_intv    real      Interval in STEPS that the SERVER should reconnect
**                                  to the master server.
**      timeouts          real      Timeout in STEPS after which server and client give
**                                  up to connect to each other.
**      debug             boolean   If true, log all debug information, alert on error and warning
**                                  Default setting: Log debug and warning, alert on error
**      silent            boolean   If true, log nothing, alert on nothing.
**                                  Default setting: Log debug and warning, alert on error
**                                  (ignored if debug is set to true) 
**
**  Returns:
**      <nothing>
**
*/

/* First: Setup enums */
enum udphp_dbglvl {DEBUG,WARNING,ERROR}
enum udphp_dbgtarget {MAIN,SERVER,CLIENT}
enum udphp_packet {
    KNOCKKNOCK=-3,
    MASTER=-1,
    MASTER_NOTFOUND=-2,
    SERVWELCOME=-4,
    DATAREQ=-5,
    DATA=-6,
    MASTER_LOBBY=-7,
}

var master_ip = argument0;
var master_port = argument1;
var reconnect_intv = argument2;
var timeouts = argument3;
var debug = argument4;
var silent = argument5;

global.udphp_master = master_ip;
global.udphp_master_port = master_port;
global.udphp_debug = debug;
global.udphp_silent = silent
global.udphp_connection_timeouts = timeouts;
global.udphp_server_udp = -1;
global.udphp_server_tcp = -1;
global.udphp_server_master_tcp = -1;
global.udphp_server_buffer = -1;
global.udphp_server_counter = -1;
global.udphp_server_incoming_requests = -1;
global.udphp_server_incoming_requests2 = -1;
global.udphp_server_players = -1;
global.udphp_server_reconnect = reconnect_intv;
global.udphp_server_data1 = "";
global.udphp_server_data2 = "";
global.udphp_server_data3 = "";
global.udphp_server_data4 = "";
global.udphp_server_data5 = "";
global.udphp_server_data6 = "";
global.udphp_server_data7 = "";
global.udphp_server_data8 = "";
global.udphp_downloadServerlistSocket = -1;
global.udphp_tmp_data1 = "";
global.udphp_tmp_data2 = "";
global.udphp_tmp_data3 = "";
global.udphp_tmp_data4 = "";
global.udphp_tmp_data5 = "";
global.udphp_tmp_data6 = "";
global.udphp_tmp_data7 = "";
global.udphp_tmp_data8 = "";
global.udphp_clients_udp = ds_map_create();
global.udphp_clients_tcp = ds_map_create();
global.udphp_clients_buffer = ds_map_create();
global.udphp_clients_timeout = ds_map_create();
global.udphp_clients_directconnect = ds_map_create();
global.udphp_clients_connected = ds_map_create();
global.udphp_clients_serverip = ds_map_create();
global.udphp_clients_serverport = ds_map_create();
global.udphp_version = "1.2.3";

global.udphp_downloadlist_refreshing = false;
global.udphp_downloadlist_topmap = -1;
global.udphp_downloadlist = -1;

udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.MAIN, 0, "Started.");
