///hhtme_createSingleSignedPacket(cmd_list,target,category,[timeout]);

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      USE htme_createSignedPacket! This is only used internally!
**      
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      cmd_list  ds_list   a ds_list containing the content that will be written in
**                          the buffer.
**      target    mixed     ip:port or noone
**      category  string    Only one signed packet of this category per target
**                          will exist at a time. The old ones will be removed
**      [timeout] real      if specified, this will overwrite the default timeout
**
**  Returns:
**      <nothing>
**
*/

var cmd_list = argument[0];
var target  = argument[1];
var category  = argument[2];
var timeout = self.global_timeout;
if (argument_count > 3) {
    timeout = argument[3];
}

// Generate new hash for this packet
var phash = htme_hash();
// Add packethash to 2nd position in list:
ds_list_insert(cmd_list,0,phash);
ds_list_insert(cmd_list,0,buffer_string);
// Add a new packet type to the beginning; SignedPacket Type
ds_list_insert(cmd_list,0,htme_packet.SIGNEDPACKET);
ds_list_insert(cmd_list,0,buffer_s8);
//New list is now buffer_s8,type,buffer_s8,hash,OLDMAP

//Don't let the server send to noone
if (is_real(target) && self.isServer) {
    htme_debugger("htme_createSingleSignedPacket",htme_debug.WARNING,"Could not create singned packet: Server tried sending to itself");
    exit;
}
//Don't let the client send to someone
if (!is_real(target) && !self.isServer) {
    htme_debugger("htme_createSingleSignedPacket",htme_debug.WARNING,"Could not create singned packet: Client tried sending to someone other than the server");
    exit;
}
if (is_real(target) && !self.isServer) {
    //Client: Build ip:port pair
    target = self.server_ip+":"+string(self.server_port);
}

htme_debugger("htme_createSingleSignedPacket",htme_debug.DEBUG,"Creating single signed packet with hash "+phash+" to "+target+"...");


//Pack packet
var packet = ds_map_create();
packet[? "cmd_list"] = cmd_list;
packet[? "target"] = target;
packet[? "timeout"] = timeout;
packet[? "hash"] = phash;
realCategory = category+"_"+target
packet[? "cat"] = realCategory;

//Add packet to outgoing packet list
ds_list_add(self.signedPackets,packet);
//Add packet to category map. If a packet in this map already exists with this category:
//REMOVE!
packetWithThisCategory = ds_map_find_value(self.signedPacketsCategories,realCategory);
if (!is_undefined(packetWithThisCategory)) {
   for(var i=0; i<ds_list_size(self.signedPackets); i+=1) {
        var CheckAgainst = ds_list_find_value(self.signedPackets,i);
        if (CheckAgainst[? "hash"] == packetWithThisCategory[? "hash"]) {
           htme_removeSignedPacket(i);
           break;
        }
    }
}
ds_map_replace(self.signedPacketsCategories,realCategory,packet);

//Send packet
htme_sendSignedPacket(ds_list_size(self.signedPackets)-1);