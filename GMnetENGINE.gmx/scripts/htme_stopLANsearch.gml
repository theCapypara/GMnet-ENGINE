///htme_stopLANsearch();

/*
**  Description:
**      Stop LAN search.
**      Destroys LAN searching server.
**
**  Arguments:
**      <none>
**
**  Returns:
**      <nothing>
**
*/

with (global.htme_object) {
    lanlobbysearch = false;
    network_destroy(lanlobbysearchserver);
    lanlobbysearchserver=noone;
}
