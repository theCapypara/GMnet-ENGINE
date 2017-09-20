// Calc Pos
texture_set_interpolation(false);
switch (Text_halign)
{
    case fa_left: xpos=0; break;
    case fa_center: xpos=sprite_width*0.5; break;
    case fa_right: xpos=sprite_width; break;
}
switch (Text_valign)
{
    case fa_top: ypos=0; break;
    case fa_middle: ypos=sprite_height*0.5; break;
    case fa_bottom: ypos=sprite_height; break;
}

draw_set_font(Text_Font);
draw_set_color(Text_Color);

// Set text config
draw_set_halign(Text_halign);
draw_set_valign(Text_valign);

// Calc
if Text_Auto_Wrap
{ 
    text_width=string_width_ext(Text_To_Draw,-1,sprite_width);
    text_height=string_height_ext(Text_To_Draw,-1,sprite_width);  
}
else
{  
    text_width=string_width(Text_To_Draw);
    text_height=string_height(Text_To_Draw);
}
if text_width=0 text_width=1;
if text_height=0 text_height=1;

xratio=sprite_width/text_width;
yratio=sprite_height/text_height;
if Text_allow_different_xyscale=false
{
    if xratio>yratio
    {
        xratio=yratio;
    }
    else
    {
        yratio=xratio;
    }
}

if Text_Max_Scale>-1
{
    if xratio>Text_Max_Scale xratio=Text_Max_Scale;
    if yratio>Text_Max_Scale yratio=Text_Max_Scale;
}   

// Fix zero division
if xratio=0 xratio=0.01;

if Text_Auto_Wrap
{      
    draw_text_ext_transformed_colour(x+xpos,y+ypos,Text_To_Draw,-1,sprite_width/xratio,xratio,yratio,image_angle,Text_Color,Text_Color,Text_Color,Text_Color,image_alpha);
}
else
{
    draw_text_transformed_colour(x+xpos,y+ypos,Text_To_Draw,xratio,yratio,image_angle,Text_Color,Text_Color,Text_Color,Text_Color,image_alpha);
}
