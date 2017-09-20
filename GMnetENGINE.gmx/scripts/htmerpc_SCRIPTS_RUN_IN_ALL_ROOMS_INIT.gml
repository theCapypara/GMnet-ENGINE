/// htmerpc_SCRIPTS_RUN_IN_ALL_ROOMS_INIT();
// script_get_name(script)

// Allow scripts to run on server even if the sender is in another room
allow_to_run_in_any_room_server[0]="";

// Allow scripts to run on client even if the sender is in another room
// Or when the client send a message and, while waited on the return, moved to another room
allow_to_run_in_any_room_client[0]="";
