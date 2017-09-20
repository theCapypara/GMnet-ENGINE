///htme_serverEventHandlerConnecting(script);

/*
**  Description:
**      Call a script if a new player connected. This script has to meet the following
**      specifications:
**      
**          Arguments:
**              player_map      ds_map      a ds_map with the keys ip and port, which contain
**                                          ip and port of the player
**              
**          Returns:
**              TRUE if the connection is accepted. The engine will then register the player
**              FALSE if the connection should be refused, the server will abort connection
**  
**  Arguments:
**      script     ressource id of a script   The script to call when a player connected.
**
**  Returns:
**      <nothing>
**
*/

global.htme_object.serverEventHandlerConnect = argument0;
