/// scr_steam_debug_message(message);
with obj_steam
{
    if show_steam_debug_messages
    {
        show_debug_message("Steam: " + string(argument0));
    }
}
