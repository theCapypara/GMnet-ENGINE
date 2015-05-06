///htme_serverEventHandlerDisconnecting(script);

/*
**  Description:
**      Call a script if a player disconnected. This script has to meet the following
**      specifications:
**      
**          Arguments:
**              player_map      ds_map      a ds_map with the keys ip and port and hash, 
**                                          which contain ip, port and hash of the player
**              
**          Returns:
**              <nothing>
**
**  Arguments:
**      script     ressource id of a script   The script to call when a player disconnected.
**
**  Returns:
**      <nothing>
**
*/

global.htme_object.serverEventHandlerDisconnect = argument0;
