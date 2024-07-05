#!/bin/bash

if systemctl --user is-active docker-desktop > /dev/null 2>&1
then
    echo "docker desktop is open"
else
    systemctl --user start docker-desktop
fi

