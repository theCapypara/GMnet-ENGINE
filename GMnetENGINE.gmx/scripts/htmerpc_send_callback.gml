///htmerpc_send_callback(rpc room,script,to,[argument0...13])
/* Sends RPC calls to another player */

/* 
 * Turn script into a string. You call this function with (htmerpc(my_script,...); 
 * my_script will be turned into a number by Game Maker that identifies this script, 
 * we turn this into a string to send it over the network, because if you use 
 * different versions of your game, this id might not be the same for the same script.
 */
var rid = "";
var script = script_get_name(argument[1]); 
var to = argument[2]; //Hash of the player to send this to
var rpc_argument;
if (argument_count > 3) rpc_argument[0] = argument[3];
if (argument_count > 4) rpc_argument[1] = argument[4];
if (argument_count > 5) rpc_argument[2] = argument[5];
if (argument_count > 6) rpc_argument[3] = argument[6];
if (argument_count > 7) rpc_argument[4] = argument[7];
if (argument_count > 8) rpc_argument[5] = argument[8];
if (argument_count > 9) rpc_argument[6] = argument[9];
if (argument_count > 10) rpc_argument[7] = argument[10];
if (argument_count > 11) rpc_argument[8] = argument[11];
if (argument_count > 12) rpc_argument[9] = argument[12];
if (argument_count > 13) rpc_argument[10] = argument[13];
if (argument_count > 14) rpc_argument[11] = argument[14];
if (argument_count > 15) rpc_argument[12] = argument[15];

var rpc_command = ds_map_create();

rpc_command[? "id"] = rid;
rpc_command[? "script"] = script;
rpc_command[? "room"] = argument[0];

//If argument_count is 4, we have 4 arguments, which means 1 rpc argument etc.
var rpc_argument_count = argument_count-3; 
rpc_command[? "argument_count"] = rpc_argument_count;

//Now we loop through all arguments and add them to the list:
for (var i = 0; i < rpc_argument_count; i++) 
{
    rpc_command[? "argument"+string(i)] = rpc_argument[i];
}

var message = json_encode(rpc_command);
//After that we don't need the map anymore
ds_map_destroy(rpc_command);

with (obj_htme_rpc)
{
    mp_chatSend(message,"",to);
}
