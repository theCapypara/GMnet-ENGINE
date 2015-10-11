///htme_setGamename(name)

/*
**  Description:
**      Can be executed after htme_init has been called.
**      Sets the game of the game . Can be used to identify different game
**      versions and game modes.
**      (self.gamename; see htme_init or BONUS 1 chapter in manual for details)
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      name     string   New gamename string
**
**  Returns:
**      <nothing>
**
*/

with (global.htme_object) {

    self.gamename = argument0;
    //Sync with GMnet PUNCH
    if (self.started && self.isServer && self.use_udphp) {
        script_execute(asset_get_index("udphp_serverSetData"),1,argument0);
    }

}
