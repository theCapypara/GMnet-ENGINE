///htme_iteratePlayers()

/*
**  Description:
**      This loops (iterates) over all players in the engine.
**      This means everytime you call it, it will return the next playerhash,
**      until it returns false, in which case the end of the list has been reached.
**      After you are done with iterating, set the iterator back by calling:
**        * htme_iteratePlayersReset();
**
**      Example:
**          var player = htme_iteratePlayers();
**          while(player) {
**              //Do something with player
**              player = htme_iteratePlayers();
**          }
**          htme_iteratePlayersReset();
**  
**  Usage:
**      <see above>
**
**  Arguments:
**      <nothing>
**
**  Returns:
**      playerhash, or false if end of list has been reached.
**
*/

var htme = global.htme_object;

var player = ds_list_find_value(htme.playerlist,htme.playerlist_i);
htme.playerlist_i++;
if (is_undefined(player)) {
   return false;
} else {
   return player;
}
