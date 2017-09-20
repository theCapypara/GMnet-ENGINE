///htme_getPlayers()

/*
**  Description:
**      This returns a ds_list containing all playerhashes.
**      Don't modify!
**
**      Example:
**          var playerlist = htme_getPlayers();
**          for(var i = 0;i<ds_list_size(playerlist);i++) {
**              var player = ds_list_find_value(playerlist,i);
**              //Do something
**          }
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
return global.htme_object.playerlist;
