/// htme_get_count();

/*  INTERNAL COMMAND
**  Description:
**      Get step time or delta time to the counter who call this script
**  
**  Usage:
**      htme_get_count()
**
**  Returns:
**      real (step 1 or delta time)
**
*/
if global.htme_object.use_delta_time {
    return delta_time*0.000001;
} else {
    return 1;
}
