/// scr_steam_init();

// Check if steam is enabled in game
steam_access=steam_net_check_version();

// Show if all is well
scr_steam_debug_message("Got access:" + string(steam_access));

// Reset retry
scr_steam_retry_reset();

// lobby owner id
lobby_owner=noone;

// invite steam id
invite_id=noone;

// command
state_command="";

// Set if we got a lobby
created_lobby=false;

// when we run some kind of lobby or join
steam_enabled=false;

// Max players
max_steam_players=32;

state="init";

state_last="";
