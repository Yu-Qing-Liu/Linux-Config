#!/bin/bash

if pgrep -x "pgadmin4" > /dev/null
then
    echo "%{B#3FFFFFFF}%{u#39949C}%{+u}  %{T3}%{T1}  %{-u}%{B-} "
else
    echo "%{B#0FFFFFFF}%{u#373B41}%{+u}  %{T3}%{T1}  %{-u}%{B-} "
fi
