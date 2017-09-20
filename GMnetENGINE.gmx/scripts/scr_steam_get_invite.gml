/// scr_steam_get_invite();

// Call in lobby to add steamID as filter

with obj_steam
{
    // Check if got invite id, else return true
    if invite_id=noone 
    {
        return "";
    }
    else
    {
        return string(invite_id);
    }
    // Reset invite
    invite_id=noone;
}
return "";
