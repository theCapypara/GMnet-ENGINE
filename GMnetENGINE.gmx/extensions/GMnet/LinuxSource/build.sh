#!/bin/sh
gcc -c -Wall -Werror -fpic -m32 processlauncher.c
gcc -m32 -shared -o ../libprocesslauncher.so  processlauncher.o
