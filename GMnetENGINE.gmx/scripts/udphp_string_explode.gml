///udphp_sstring_explode(str,sep,index)

/*  INTERNAL COMMAND
**  Usage:
**      udphp_string_explode(str,sep,index)
**
**  Arguments:
**      str         string of elements
**      sep         character or string seperating the elements
**      index       element to return, {0..n-1}
**
**  Returns:
**      the element at the given index within a given string of elements
**
**  original created by xot @ GMLscripts.com (http://www.gmlscripts.com/script/explode_string)
*/
{
    var str,sep,ind,len;
    str = argument0;
    sep = argument1;
    ind = argument2;
    len = string_length(sep)-1;
    repeat (ind)
        str = string_delete(str,1,string_pos(sep,str)+len);
    str = string_delete(str,string_pos(sep,str),string_length(str));
    return str;
}
