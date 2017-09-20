/// htmerpc_send_add_datastring(data string);

/*
// MAX send is 1500 bytes in one buffer via the external IP
var send_array=htmerpc_split_string(Send_string,750);
var send_parts=array_length_1d(send_array);
for (var i=0; i<send_parts; i+=1)
{
    htmerpc_send_add_datastring(send_array[i]);
    htmerpc_send(htme_hash(),Draw_Recorder_Receive_Message,htme_mp_player,send_parts-i);                         
}
*/

with (obj_htme_rpc)
{
    dataString=argument0;
}
