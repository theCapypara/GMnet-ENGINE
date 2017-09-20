///htme_debugger(scriptname,level,message)

/*
**  Description:
**      This script outputs debug messages related to the text engine
**  
**  Usage:
**      <See above>
**
**  Arguments:ac
**      scriptname  string      name of the script file that output this debug message
**      level       htme_debug  Value of the enum htme_debug declared in text_setup
**      message     string      Debug message
**
**  Returns:
**      <nothing>
**
*/

var scriptname = argument0;
var level = argument1;
var message = argument2;

if (global.htme_object.debuglevel != htme_debug.NONE && level >= global.htme_object.debuglevel) {
    levelname = "UNKNOWN";
    switch (level) {
        case htme_debug.NONE:
            levelname = "NONE";
            break;
        case htme_debug.DEBUG:
            levelname = "DEBUG";
            break;
        case htme_debug.CHATDEBUG:
            levelname = "CHATDEBUG";
            break;
        case htme_debug.INFO:
            levelname = "INFO";
            break;
        case htme_debug.WARNING:
            levelname = "WARNING";
            break;
        case htme_debug.ERROR:
            levelname = "ERROR";
            break;
        case htme_debug.TRAFFIC:
            levelname = "TRAFFIC";
            break;
    }
    if (global.htme_object.debuglevel == htme_debug.TRAFFIC && level != htme_debug.TRAFFIC) exit;
    show_debug_message("MULTIPLAYER ENGINE ["+string(current_time)+"|"+string(current_hour)+":"+string(current_minute)+":"+string(current_second)+"] "+scriptname+" - "+levelname+" - "+message);
}
