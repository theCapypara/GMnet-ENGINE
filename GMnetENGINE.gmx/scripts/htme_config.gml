/*=======
 *** GMnet ENGINE CONFIGURATION
 =======*/

/** 
 * Set the level of debug. The debug messages of this level and higher
 * will be shown. NONE disables debug messages.
 * For possible levels see htme_init
 */
self.debuglevel = htme_debug.INFO;

/** 
 * Enable or disable the debug overlay. Provides you with useful debugging tools.
 * Use htme_debugOverlayEnabled() to check if the overlay is on, to draw your own
 * debug information. 
*/
self.debugoverlay = true;

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
