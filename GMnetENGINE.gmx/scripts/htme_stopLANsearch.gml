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
    self.lanlobbysearch = false;
    network_destroy(self.lanlobbysearchserver);
}
