///htme_hash()

/*
**  Description:
**      Generates a random 8 character long string.
**  
**  Usage:
**      <See above>
**
**  Arguments:
**      <None>
**
**  Returns:
**      The generated string
**
*/
var str = "";
for (var i=0;i<6;i++) {
    str = str+chr(random_range(48,122));
}
// Add counter and player number to hash, to make it unique
if global.htme_object.playerhash!=""
{
    str+=string(global.htme_object.hash_counter)+string(htme_getPlayerNumber(global.htme_object.playerhash));
}
else
{
    // When generating player hash ignore use player number
    str+=string(global.htme_object.hash_counter);
}
return str;
