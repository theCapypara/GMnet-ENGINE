/// htmerpc_Allow_Run_Script_Current_Room(script,rpc room);

var rpc_room=argument1;

// Check if in same room as rpc sender
// Fast check when server is in the same room
// Or when client got a callback that he sent from the same room
if room=rpc_room return true;

// Allow in server when client is in another room
if htme_isServer()
{
    with obj_htme_rpc
    {
        for (var i=0; i<array_length_1d(allow_to_run_in_any_room_server); i+=1)
        {
            if allow_to_run_in_any_room_server[i]=argument0
            {
                return true;
            }
        }
    }
}
else
{
    // Allow in client when server or other client is in another room
    with obj_htme_rpc
    {
        for (var i=0; i<array_length_1d(allow_to_run_in_any_room_client); i+=1)
        {
            if allow_to_run_in_any_room_client[i]=argument0
            {
                return true;
            }
        }
    }
}

return false;
