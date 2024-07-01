#!/bin/bash

if pgrep -x "pgadmin4" > /dev/null
then
    firefox http://127.0.0.1:5050
else
    cd /var/lib/pgadmin
    source pgadmin4/bin/activate
    pgadmin4 &
    firefox http://127.0.0.1:5050
fi

