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
for (var i=0;i<8;i++) {
    str = str+chr(random_range(48,122));
}
return str;
