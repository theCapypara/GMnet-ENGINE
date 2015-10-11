///htme_ds_map_find_key(index,value);

//TODO: Add doc. Searches for value, returns first key

var m = argument0;
var invalue = argument1;

var key= ds_map_find_first(m);
//This will loop through the map
for(var i=0; i<ds_map_size(m); i+=1) {
    var val = ds_map_find_value(m,key);
    if (val == invalue) return key;
    key = ds_map_find_next(m, key);
}
return undefined;
