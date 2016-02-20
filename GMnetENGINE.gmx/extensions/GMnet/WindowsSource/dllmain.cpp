#include "dll.h"
#include <windows.h>
#define DLLEXPORT extern "C" __declspec(dllexport)
DLLEXPORT double ProcessLaunch(char* myProcessName, char* myProcessDirectory, char* myProcessArgs)
{
    ShellExecute(NULL,
    "open",
    myProcessName,
    myProcessArgs,
    myProcessDirectory,
    SW_SHOWNORMAL);
    return 0;
}

DLLEXPORT double ProgramLaunch(char* myProcessName, char* myProcessDirectory, char* myProcessArgs, double myProcessWait)
{
    STARTUPINFO si;
    PROCESS_INFORMATION pi;
    int spi = sizeof(pi);
    int ssi = sizeof(si);            
    memset(&si, 0, sizeof(si));
    si.cb = sizeof(STARTUPINFO);
    ZeroMemory(&pi, sizeof(pi));
    int b = 0;
    b = CreateProcess(
    myProcessName,
    myProcessArgs,
    NULL,
    NULL,
    0,
    CREATE_NO_WINDOW,
    NULL,
    myProcessDirectory,
    &si,
    &pi);
    if (myProcessWait)
    {
        WaitForSingleObject(pi.hProcess, INFINITE);      
    }
    return 0;
}