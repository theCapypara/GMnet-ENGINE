/// scr_steam_STEP();

// Show state
scr_steam_show_state();

// Get updates from steamworks
if steam_access
{
    steam_net_update();
}

switch (state)
{
    case "init": 
        // Init values
        state="wait for command";
        break;
    case "wait for command":
        // Wait for start server or join
        break;
    case "create lobby":
        if steam_access
        {
            steam_lobby_create(lobby_type, max_steam_players);
            state="wait for create lobby";
        }
        else
        {
            state="no steam access - start steam.exe and restart game";
        }
        break;
    case "wait for create lobby":
        //Wait here until got lobby callback
        break;
    case "lobby created":
        // Do stuff while we got a lobby
        // Check if we lost the lobby
        if steam_lobby_get_owner_id()!=lobby_owner
        {
            // Reset
            scr_steam_soft_clean();
            state="lobby lost";
        }
        else
        {
            // Wait for lobby commands
            switch (state_command)
            {
                case "show invite screen": 
                    steam_lobby_activate_invite_overlay();
                    break;
            }
            // Reset
            state_command="";
        }
        break;
    case "lobby lost":
    case "lobby create fail":
        // Lobby create fail or lost, wait some and retry
        scr_steam_timeout_start("wait");
        state="wait until try again";
        break;
    case "wait until try again":
        scr_steam_timeout_handler("wait");
        break;
    case "start re-enable wait":
        scr_steam_timeout_start("re-enable");
        state="wait for re-enable";
        break;
    case "wait for re-enable":
        scr_steam_timeout_handler("re-enable");
        break;
    case "joinded":
        // We are playing
        break;
}
 
