/// udphp_get_count();

/*  INTERNAL COMMAND
**  Description:
**      Get step time or delta time to the counter who call this script
**  
**  Usage:
**      udphp_get_count()
**
**  Returns:
**      real (step 1 or delta time)
**
*/
if global.udphp_deltatime {
    return delta_time*0.000001;
} else {
    return 1;
}
