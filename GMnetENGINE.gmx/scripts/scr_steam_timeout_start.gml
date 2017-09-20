/// scr_steam_timeout_start(type);
switch (argument0)
{
    case "wait":
        steam_wait_timeout=steamworks_timeout;
        break;
    case "re-enable":
        steam_wait_timeout=steamworks_re_enable_timeout;
        break;             
}
