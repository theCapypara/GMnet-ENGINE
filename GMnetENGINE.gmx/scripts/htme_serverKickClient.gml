///htme_serverKickClient(client_ip_port);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Removes a player from the map of players.
**      This means the player kicked doesn't get noticed that he was disconnected and slowly
**      times out! If you want to inform that player, use htme_serverDisconnect
**  
**  Usage:
**      ip:port     string      ip:port combination as stored as key in the player map.
**                              If you want to disconnect via player hash use htme_serverDisconnect
**
**  Arguments:
**      <none>
**
**  Returns:
**      <nothing>
**
*/

if (!ds_map_exists(self.playermap,argument0)) exit;
htme_debugger("htme_serverKickClient",htme_debug.INFO,"KICKING "+argument0);
htme_serverEventPlayerDisconnected(argument0);
htme_debugger("htme_serverKickClient",htme_debug.INFO,"KICKED "+argument0);
ds_map_delete(self.playermap,argument0);
ds_map_delete(self.playerrooms,argument0);
ds_map_delete(self.serverTimeoutSend,argument0);
ds_map_delete(self.serverTimeoutRecv,argument0);
if (self.use_udphp) {
    //Remove from udphp player list
    var pos = ds_list_find_index(self.udphp_playerlist,argument0);
    if (pos != -1)
        ds_list_delete(self.udphp_playerlist,pos);
}
