///htme_serverBroadcastUnsync(hash,[target])

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Tells all clients that a instance with the internal id has should not
**      be synced anymore. This will not remove the instance from the local
**      or global list of instances.
**  
**  Usage:
**      hash           string    the hash of the instance in the engine
**      [target]       string    ip:port, if not given, this will be sent to all
**
**  Arguments:
**      <nothing>
**
**  Returns:
**      <none>
**
*/

var hash = argument[0];

//Creates a signed packet and sends it to the server
cmd_map = ds_list_create();
//Create command map
cmd_map[| 0] = buffer_s8;
cmd_map[| 1] = htme_packet.SERVER_INSTANCEREMOVED;

cmd_map[| 2] = buffer_string;
cmd_map[| 3] = hash;

if (argument_count > 1) {
   htme_debugger("htme_clientBroadcastUnsync",htme_debug.TRAFFIC,"Creating signed packet htme_packet.SERVER_INSTANCEREMOVED for "+argument[1]);
   //FIXME: We are throwing away all sPs currently, we should focus
   //one the ones for one player
   htme_removeSignedPacketsByCatFilter(hash);
   htme_createSignedPacket(cmd_map,argument[1],hash+"__REMOVE_");
} else {
  htme_debugger("htme_clientBroadcastUnsync",htme_debug.TRAFFIC,"Creating signed packet htme_packet.SERVER_INSTANCEREMOVED for all clients");
  htme_removeSignedPacketsByCatFilter(hash);
  htme_createSignedPacket(cmd_map,all,hash+"__REMOVE_");
}