///udphp_handleerror(type,component,client_id,message)

/*  INTERNAL COMMAND
**  Description:
**      "Logs" everything related to GMnet PUNCH
**  
**  Usage:
**      udphp_handleerror(type,component,client_id,message)
**
**  Returns:
**      <nothing>
**
*/

//I'm not going into detail with this scripts, since it kinda explains itself.

var type = argument0;
var component = argument1;
var client_id = argument2;
var message = argument3;
var debug = global.udphp_debug;
var silent = global.udphp_silent;
        
if (!silent) {

var pretext = "-- UDPHP : "

switch component {
    case udphp_dbgtarget.MAIN:
    default:
        pretext += "MAIN - ";
    break;
    case udphp_dbgtarget.SERVER:
        pretext += "SERVER - ";
    break;
    case udphp_dbgtarget.CLIENT:
        pretext += "CLIENT "+string(client_id)+" - ";
    break;
}

switch type {
    case udphp_dbglvl.ERROR:
        pretext += message;
        show_debug_message(pretext);
        show_message(pretext);
    break;
    case udphp_dbglvl.WARNING:
        pretext += message;
        show_debug_message(pretext);
        if (debug) show_message(pretext);
    break;
    case udphp_dbglvl.DEBUG:
    default:
        pretext += message;
        if (debug) show_debug_message(pretext);
    break;
}

}
