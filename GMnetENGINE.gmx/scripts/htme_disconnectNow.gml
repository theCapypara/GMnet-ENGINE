///htme_disconnectNow()

/*
**  Description:
**      Disconnect and clean client or server when game started
**      This is very handy, just call it and if return true then 
**      clean your ds maps and lists and go to another room
**      This will restart the engine, ready to to whatever you want.
**      Like connect again, start server, lobby...
**      Like a game restart without the game_restart()
**  
**  Usage:
**      <see above>
**
**  Arguments:
**      <none>
**
**  Returns:
**      true, if ok disconnect, false if not.
**
*/
if instance_exists(global.htme_object) {
    with global.htme_object {
        if (self.isConnected) {
            // Clean everything
            if self.isServer {
                with global.htme_object htme_serverShutdown();
            } else {
                with global.htme_object htme_clientDisconnect();
            }
            // Stop steam
            scr_steam_clean();
            return true;
        }
    }
} else {
    return false;
}
return false;
