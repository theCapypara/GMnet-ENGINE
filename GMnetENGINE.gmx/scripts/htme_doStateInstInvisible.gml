///htme_debugoverlayStateInstInvisible();

/*
**  Description:
**      PRIVATE "METHOD" OF obj_htme! That means this script MUST be called with obj_htme!
**
**      Draw debug information of invisible instances
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
htme_debugoverlayDrawInstanceTable("INVISIBLE INSTANCES",2,all,true);
