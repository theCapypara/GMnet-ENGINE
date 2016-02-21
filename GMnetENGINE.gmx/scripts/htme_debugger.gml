///htme_debugger(scriptname,level,message, [isPunch])

/*
**  Description:
**      This script outputs debug messages related to GMnet ENGINE/PUNCH
**  
**  Usage:
**      <See above>
**
**  Arguments:ac
**      scriptname  string      name of the script file that output this debug message
**      level       htme_debug  Value of the enum htme_debug declared below
**      message     string      Debug message
**      isPunch     boolean     If true: Message was sent by GMnet PUNCH
**
**  Returns:
**      <nothing>
**
*/

enum htme_debug {
    NONE=-1,
    DEBUG=0,
    CHATDEBUG=2,
    INFO=3,
    WARNING=4,
    ERROR=5
};

//exit; - Take this line out to enable production mode where logging is disabled

var scriptname = argument[0];
var level = argument[1];
var message = argument[2];
var ispunch = false;
if (argument_count > 3) {
    ispunch = argument[3];
}
var product = "ENGINE";
if (ispunch) {
    product = "PUNCH ";
}

if (global.htme_debuglevel != htme_debug.NONE && level >= global.htme_debuglevel) {
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
    }
    show_debug_message("GMnet "+product+" ["+string(current_time)+"|"+string(current_hour)+":"+string(current_minute)+":"+string(current_second)+"] "+scriptname+":"+string(id)+" - "+levelname+" - "+message);
}
