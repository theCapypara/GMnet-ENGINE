///htme_clientBroadcastUnsync(hash)

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Tells the server that a instance with the internal id has should not
**      be synced anymore. This will not remove the instance from the local
**      or global list of instances.
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      hash    string    the hash of the instance in the engine
**
**  Returns:
**      <none>
**
*/

var hash = argument0;

//Creates a signed packet and sends it to the server
cmd_map = ds_list_create();
//Create command map
cmd_map[| 0] = buffer_s8;
cmd_map[| 1] = htme_packet.CLIENT_INSTANCEREMOVED;

cmd_map[| 2] = buffer_string;
cmd_map[| 3] = hash;
htme_debugger("htme_clientBroadcastUnsync",htme_debug.TRAFFIC,"Creating signed packet htme_packet.CLIENT_INSTANCEREMOVED for server");
htme_removeSignedPacketsByCatFilter(hash);
htme_createSignedPacket(cmd_map,noone,hash+"__REMOVE_");