/// scr_String_To_Buffer(string);
var stringbuffer=argument0;
var return_buffer=buffer_create(string_length(stringbuffer),buffer_fixed,1);
var current_char_value=0;

//show_debug_message("From String:")
// Convert string to buffer
for (var i=0; i<string_length(stringbuffer); i+=1)
{
    current_char_value=ord(string_char_at(stringbuffer,i+1))-1;
    //show_debug_message(current_char_value)
    buffer_write(return_buffer,buffer_u8,current_char_value);
}
// Go to the beginning of the buffer
buffer_seek(return_buffer, buffer_seek_start, 0);

// Return the buffer
return return_buffer;
