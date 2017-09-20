/// scr_steam_on_SendSteamIDToLobby(SteamID);

// Will run when the steam got id data to set in the lobby

var public_lobby_string=string(argument0);

// Set new data
htme_setData(7,public_lobby_string);

scr_steam_debug_message("Add ID to lobby: " + string(public_lobby_string));

// ===================
// Send data to server
// ===================
if global.htme_object.use_udphp
{
    udphp_serverCommitData();
}
/*
if global.htme_object.gmon_enabled
{
    gmon_serverCommitData();
}
*/
