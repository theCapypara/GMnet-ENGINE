///htme_debugoverlayStateInstInvisible();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Draw debug information of cached instances
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      <None>
**
**  Returns:
**      <Nothing>
**
*/
htme_debugoverlayStateMain();
htme_debugoverlayDrawInstanceTable("INSTANCES IN CACHE#(The server stores client instances in other rooms in cache)",3,all,true);
