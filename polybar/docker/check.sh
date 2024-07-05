#!/bin/bash

# Function to check if the Docker Desktop window is active
function is_docker_desktop_active() {
    xdotool search --onlyvisible --classname "docker desktop" > /dev/null 2>&1
}

# Main script
if is_docker_desktop_active; then
    echo "%{B#3FFFFFFF}%{u#39949C}%{+u}  %{T3}%{T1}  %{-u}%{B-} "
else
    echo "%{B#0FFFFFFF}%{u#373B41}%{+u}  %{T3}%{T1}  %{-u}%{B-} "
fi

