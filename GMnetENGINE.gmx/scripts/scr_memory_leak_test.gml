/// scr_memory_leak_test();
var tot_lists=0;
var tot_maps=0;
var tot_queues=0;
var tot_grid=0;
var tot_priority=0;
var tot_stacks=0;
var tot_buffers=0;

var tot_lists_nr="";
var tot_maps_nr="";
var tot_queues_nr="";
var tot_grid_nr="";
var tot_priority_nr="";
var tot_stacks_nr="";
var tot_buffers_nr="";

var tot_lists_size=0;
var tot_maps_size=0;
var tot_queues_size=0;
var tot_grid_size=0;
var tot_priority_size=0;
var tot_stacks_size=0;
var tot_buffers_size=0;

for (var i=0; i<5000; i+=1)
{
    if ds_exists(i,ds_type_list) then
    {
        tot_lists+=1;
        tot_lists_size+=ds_list_size(i);
        tot_lists_nr+="," + string(i);
        if i=memory_leak_check show_debug_message("List: " + string(i) + " size: " + string(ds_list_size(i)));
    }
    if ds_exists(i,ds_type_map) then
    {
        tot_maps+=1;
        tot_maps_size+=ds_map_size(i);
    }  
    if ds_exists(i,ds_type_grid) then
    {
        tot_grid+=1;
        tot_grid_size+=ds_grid_width(i)+ds_grid_height(i);
    }  
    if ds_exists(i,ds_type_priority) then
    {
        tot_priority+=1;
        tot_priority_size+=ds_priority_size(i);
    }    
    if ds_exists(i,ds_type_queue) then
    {
        tot_queues+=1;
        tot_queues_size+=ds_queue_size(i);
    }   
    if ds_exists(i,ds_type_stack) then
    {
        tot_stacks+=1;
        tot_stacks_size+=ds_stack_size(i);
    }    
    /*
    if buffer_exists(i) then
    {
        tot_buffers+=1;
        tot_buffers_size+=buffer_get_size(i);
    }
    */           
}
show_debug_message("Total ds structures:");
show_debug_message("Lists:" + string(tot_lists) + " nr:" + string(tot_lists_nr) + " size:" + string(tot_lists_size));
show_debug_message("Maps:" + string(tot_maps) + " size:" + string(tot_maps_size));
show_debug_message("Priority:" + string(tot_priority) + " size:" + string(tot_priority_size));
show_debug_message("Queues:" + string(tot_queues) + " size:" + string(tot_queues_size));
show_debug_message("Stacks:" + string(tot_stacks) + " size:" + string(tot_stacks_size));
show_debug_message("Buffers:" + string(tot_buffers) + " size:" + string(tot_buffers_size));
