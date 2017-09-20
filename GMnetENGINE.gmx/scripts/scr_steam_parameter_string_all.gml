/// scr_steam_parameter_string_all()
var r = "";
var n = parameter_count();
for (var i = 0; i < n; i++) {
    if (i > 0) r += " ";
    var s = parameter_string(i);
    if (string_pos(" ", s)) {
        r += '"' + s + '"';
    } else r += s;
}
return r;
