/// scr_steam_config();

// Show debug
show_steam_debug_messages=true;

// Lobby type:
// steam_lobby_type_private: Can only be joined by invitation
// steam_lobby_type_friends_only: Can be joined by invitation or via friends-list (by opening the user' menu and picking "Join game").
// steam_lobby_type_public: Can be joined by invitation, via friends-list, and shows up in the public lobby list, can be used for matchmaking. (Your game must have matchmaking API enabled (is off by default for free games - request permissions via support forum))
lobby_type=steam_lobby_type_private;

// Use steam network or GMnet network
use_steam_network = false;

// Retry when fail
steamworks_retry=3;

// Timeout in seconds
steamworks_timeout=5;

// Re-enable timeout (in seconds)
steamworks_re_enable_timeout=60*3;
