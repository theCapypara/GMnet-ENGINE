/// scr_steam_show_state();
if state!=state_last
{
    scr_steam_debug_message(state);
    // Save new state
    state_last=state;
}
