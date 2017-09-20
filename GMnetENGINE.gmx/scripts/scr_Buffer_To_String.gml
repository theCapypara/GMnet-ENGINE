/// scr_Buffer_To_String(buffer, [bool use tell value]);
var return_string="";
var thebuffer=argument[0];
var buffer_value=0;

if argument_count>1
{
    // Get current tell value
    use_size=buffer_tell(thebuffer);
    // Rewind buffer
    buffer_seek(thebuffer, buffer_seek_start, 0);    
}
else
{
    var use_size=buffer_get_size(thebuffer);
}

//show_debug_message("To String:")
for (var i=0; i<use_size; i+=1)
{
    buffer_value=buffer_read(thebuffer,buffer_u8);
    //show_debug_message(buffer_value);
    return_string+=chr(buffer_value+1);
}

return return_string;
