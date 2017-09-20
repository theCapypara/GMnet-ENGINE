/// scr_steam_timeout_handler(type);

var currentTimer=0;
switch (argument0)
{
    case "wait":
        steam_wait_timeout-=scr_steam_getCount();
        currentTimer=steam_wait_timeout;
        break;
    case "re-enable":
        steam_wait_timeout-=scr_steam_getCount();
        currentTimer=steam_wait_timeout;
        break;      
}
 
// Check if timeout
switch (argument0)
{
    case "wait":
        if currentTimer<0
        {
            // Stop current
            steam_enabled=false;
            // Check if retry
            if steam_retry>1
            {
                // Try again
                state="create lobby";
                // Count down
                gmre_retry-=1;
            }
            else
            {
                // Fail
                state="start re-enable wait";
            }
        }
        break;
    case "re-enable":
        // Check if try re-enable
        if currentTimer<0
        {
            // Try re-enable steamworks lobby
            state="create lobby";
        }        
        break;         
}
