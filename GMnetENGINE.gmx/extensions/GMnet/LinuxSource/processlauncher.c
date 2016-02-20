#include "processlauncher.h"
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

char* concat6(char *s1, char *s2, char *s3, char *s4, char *s5, char *s6)
{
    char *result = malloc(strlen(s1)+strlen(s2)+strlen(s3)+strlen(s4)+strlen(s5)+strlen(s6)+1);
    strcpy(result, s1);
    strcat(result, s2);
    strcat(result, s3);
    strcat(result, s4);
    strcat(result, s5);
    strcat(result, s6);
    return result;
}

double ProcessLaunch(char* myProcessName, char* myProcessDirectory, char* myProcessArgs)
{
    char *cmd = NULL;
    switch(fork()) {
        case -1:   /* Error */
            break;
        case  0:   /* Child */
            cmd = concat6("cd ",myProcessDirectory," && ",myProcessName," ",myProcessArgs);
            execl("/bin/sh", "/bin/sh", "-c", cmd, NULL);
            return 0;
        default:   /* Parent */
            return 0;
    }
    return 0;
}
