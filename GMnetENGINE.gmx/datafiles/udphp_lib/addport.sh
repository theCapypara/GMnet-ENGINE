#!/usr/bin/env bash
chmod +x upnpc-static
./upnpc-static -e GameMakerStudio -r "$1" UDP "$1" TCP
