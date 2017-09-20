///udphp_config(master_ip,master_port,reconnect_intv,timeouts,debug,silent,delta time,upnp)

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
**      delta time        boolean   If true, use delta time insted of step time
**                                  Default setting: false
**      upnp              boolean   If true, use upnp to port forward
**                                  Default setting: false
**
**  Returns:
**      <nothing>
**
*/

//========== CONFIGURATION ==========//

/**
 * Most of the settings can be changed by using the arguments above.
 * However here are some more advanced settings.
 * DO NOT change them here.
 * Instead change the value of these variables after calling udphp_config!
 */
 
/** 
 * PORT PREDICTION TIMEOUTS
 * The time the punch stage will wait before trying next port
 * Increase timeouts to test more ports if you have problem connecting with punch
 * If you experience overload in the router set the value to 2 or above.
 * But this will decrease the chances you connect to the server
 *
 * GMnet ENGINE users can change this setting in htme_config!
 *
 * @type real
 */
global.udphp_punch_stage_timeout_initial = 1;

//====== END CONFIGURATION ==========//

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
    GETLOCALIPBROADCAST=-8,
}

//The value of the enum is the amount of time the state should kick in in percent
enum udphp_punch_states {
    DEFAULT= 0,
    TRY_SEQUENCE_PORT= 25,
    TRY_PREDICTING_PORT= 40,
    TRY_PROVIDED_PORT= 80
}

enum udphp_punch_substates {
    DEFAULT= 0,
    SEQ_TRY_NEW= 1,
    PRED_CONTINUE= 2,
    PRED_REST= 3,
    
}

var master_ip = argument0;
var master_port = argument1;
var reconnect_intv = argument2;
var timeouts = argument3;
var debug = argument4;
var silent = argument5;
var deltatime = argument6;
var upnpenabled = argument7;

/** Set timeout for master server connection
  * TODO: Add option to specify this value
  */
network_set_config(network_config_connect_timeout, 4000);

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
global.udphp_clients = ds_map_create();
global.udphp_version = "1.2.4";
global.udphp_deltatime = deltatime;
global.udphp_upnp = upnpenabled;
global.udphp_upnp_port = 0;
global.udphp_downloadlist_refreshing = false;
global.udphp_downloadlist_topmap = -1;
global.udphp_downloadlist = -1;

udphp_handleerror(udphp_dbglvl.DEBUG, udphp_dbgtarget.MAIN, 0, "Started.");
