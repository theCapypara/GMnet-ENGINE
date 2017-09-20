/// scr_steam_create_lobby(max players);
var max_players=argument0;
with obj_steam
{
    // Set max steam players
    max_steam_players=max_players;
    // Make engine start a steam lobby
    state="create lobby";
    // Reset commands
    state_command="";
}
