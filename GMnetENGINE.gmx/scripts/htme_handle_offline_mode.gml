/// htme_handle_offline_mode(start server);
if instance_number(obj_htme_offline_mode)
{
    // If start server then enable/disable offline mode. Else reset.
    if argument0
    {
        if obj_htme_offline_mode.active
        {
            // Set dummy info
            show_debug_message("Offline mode is: Activated to hide server.")
            if instance_number(obj_htme)
            {
                obj_htme.use_udphp=false;
                obj_htme.upnp_enabled=false;
                obj_htme.lan_interval=9999;
                obj_htme.gamename=string(obj_htme_offline_mode.gamename)+"_Offline";
            }
        }
        else
        {
            // Set real info
            show_debug_message("Offline mode is: Deactivated to enable visible server.")
            if instance_number(obj_htme)
            {
                obj_htme.use_udphp=obj_htme_offline_mode.use_udphp;
                obj_htme.upnp_enabled=obj_htme_offline_mode.upnp_enabled;
                obj_htme.lan_interval=obj_htme_offline_mode.lan_interval;
                obj_htme.gamename=obj_htme_offline_mode.gamename;  
            }
        }
    }
    else
    {
        // Set original info
        show_debug_message("Offline mode is: Deactivaded to enable lobby search and client join.")
        if instance_number(obj_htme)
        {
            obj_htme.use_udphp=obj_htme_offline_mode.use_udphp;
            obj_htme.upnp_enabled=obj_htme_offline_mode.upnp_enabled;
            obj_htme.lan_interval=obj_htme_offline_mode.lan_interval;
            obj_htme.gamename=obj_htme_offline_mode.gamename;  
        }        
    }
}
