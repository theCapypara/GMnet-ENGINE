/// scr_steam_on_LoadSteamIDFromLobby(SteamID);
var steamID=string(argument0);
with obj_steam
{
    if steamID!=""
    {
        lobby_owner=real(steamID);
    }
    else
    {
        lobby_owner=noone;
    }
}
