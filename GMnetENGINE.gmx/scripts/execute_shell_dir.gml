/// execute_shell_dir(name,directory,args)
/*
    ProcessLauncher.dll by Sporkinator/Big J
    
    execute_shell_dir(name,directory,args)
    
         name - The name of the program to launch
    directory - The start up directory
         args - Any command line arguments (Optional, can be omitted)
         
    Returns whether successful
*/
if (!file_exists(argument0))
{
    return 0;
}
if (is_real(argument2))
{
    external_call(global.ProcessLaunch,argument0,argument1,"");
}
else
{
    external_call(global.ProcessLaunch,argument0,argument1,argument2);
}
return 1;