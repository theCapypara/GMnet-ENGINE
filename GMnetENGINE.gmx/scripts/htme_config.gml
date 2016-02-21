/*=======
 *** GMnet ENGINE CONFIGURATION
 =======*/

/** 
 * Set the level of debug. The debug messages of this level and higher
 * will be shown. NONE disables debug messages.
 * For possible levels see htme_debugger
 */
global.htme_debuglevel = htme_debug.INFO;

/** 
 * Enable or disable the debug overlay. Provides you with useful debugging tools.
 * Use htme_debugOverlayEnabled() to check if the overlay is on, to draw your own
 * debug information. 
*/
self.debugoverlay = true;

/** 
 * Use different versions of Game Maker Studio
 * 1: network_create_socket_ext(network_socket_udp,port); >1.4.1567
 * 2: network_create_socket(network_socket_udp); For tests
 * 3: network_create_server(network_socket_udp,port,maxclients); <=1.4.1567
 */
self.gmversionpick=1;

/** 
 * Use GMnet PUNCH? Set to true if GMnet PUNCH is installed and should be used to make the conection.
 * GMnet PUNCH is installed if you use GMnet ENGINE and needs to be installed manually
 * when using GMnet CORE.
 * More Information can be found in the manual.
 */
 
self.use_udphp = false;

/** 
 * WHEN USING GMnet PUNCH:
 * IP of the master/mediation server 
 * THERE CAN BE NO GAME SERVER RUNNING ON THIS IP!!
 * Use 95.85.63.183 if you have no server. It is only for debugging!
 * @type string
 */
self.udphp_master_ip = "95.85.63.183";

/** 
 * WHEN USING GMnet PUNCH:
 * Port of the master/mediation server 
 * @type real
 */
self.udphp_master_port = 6510;

/** 
 * Use delta time instead of room step counter
 * If you set to true you must remove all the room_speed
 * from the timers below. And in the mp_addPosition("Pos",5*room_speed);
 * remove the room_speed. The engine will use seconds instead of steps.
 * @type bool
 */
use_delta_time=false;

/** 
 * WHEN USING GMnet PUNCH:
 * Setup the portforward on the router using upnp
 * Works on Windows,Android,Linux
 * @type boolean
 */
self.upnp_enabled = false;

/** 
 * WHEN USING GMnet PUNCH:
 * The server should reconnect to the master server every x steps.
 * The server will only reconnect if it's no longer connected.
 * @type real
 */
self.udphp_rctintv = 3*60*room_speed;

/** 
 * The timeout after which the client gives up to connect.
 * This will also specify when server and client should timeout when the are not responding
 * to each others requests (ping timeout)
 * When using udphp:
 * The timeout after which the server and client give up to connect to each other.
 * @type real
 */
self.global_timeout = 5*room_speed;

/** 
 * WHEN USING GMnet PUNCH:
 * Advanced Port-Prediction Timout
 *
 * The time the punch stage will wait before trying next port
 * Increase self.global_timeout to test more ports if you have problem connecting with punch
 * If you experience overload in the router set the value to 2 or above.
 * But this will decrease the chances you connect to the server
 * @type real
 */
self.punch_stage_timeout=1*room_speed; // must wait 1 sec before next try else the Messages wont be sent or the target router will stop them

/** 
 * Interval the servers broadcast data to the LAN, for the LAN lobby
 * @type real
 */
self.lan_interval = 15*room_speed;

/**
 *  Shortname of this game
 *  + version
 *  Example: gmnet_engine_130
 *
 * If you are testing the demo project or simply play arround with the engine, ignore this.
 * Otherwise, when making your game, you need to change the gamename.
 * This string is used to identify your game. It is meant to make sure different
 * games can't connect to each other. If incompatible games would try to connect
 * to each other that would result in data corruption and crashes.
 * Also change this string when releasing a new version of your game, that is incompatible
 * with old versions of your game.
 **/
self.gamename = "gmnet_engine_130"

/** DON'T CHANGE **/
self.config_version = 1;
