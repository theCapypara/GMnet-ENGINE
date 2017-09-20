/// htmerpc_split_string(string, size);
var the_string=argument0;
var the_size=argument1;
var split_array=-1;
var string_size=string_length(the_string);
var total_sends=ceil(string_size/the_size);
var start_cut=1;
for (var i=0; i<total_sends; i+=1)
{
    // split it up
    split_array[i]=string_copy(the_string,start_cut,min(string_size-start_cut+1,the_size));
    // Add cut pos
    start_cut+=the_size;
}
return split_array;
