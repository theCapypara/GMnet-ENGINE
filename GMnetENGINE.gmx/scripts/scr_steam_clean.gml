/// scr_steam_clean();

with obj_steam
{
    // If in lobby destroy it
    if created_lobby
    {
        steam_lobby_leave();
        scr_steam_debug_message("Lobby destroyed!");
    }
    
    instance_destroy();
}

// Create new
if steam_enabled instance_create(0,0,obj_steam);
