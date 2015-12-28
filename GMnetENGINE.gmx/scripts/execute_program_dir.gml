/*
    ProcessLauncher.dll by Sporkinator/Big J
    
    execute_program_dir(name,directory,args,wait)
    
         name - The name of the program to launch
    directory - The start up directory of the Program
         args - Any command line arguments (Optional, can be omitted)
         wait - Whether to wait for the launched program to exit 
         
    Returns whether successful
*/
if (!file_exists(argument0))
{
    return 0;
}
if (is_real(argument2))
{
    external_call(global.ProgramLaunch,argument0,argument1,"",argument3);
}
else
{
    external_call(global.ProgramLaunch,argument0,argument1," "+argument2,argument3);
}
return 1;