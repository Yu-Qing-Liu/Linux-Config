#!/bin/bash

# Function to check if the Docker Desktop window is active
function is_docker_desktop_active() {
    xdotool search --classname "docker desktop" > /dev/null 2>&1
}

function is_docker_process_active() {
    systemctl --user is-active docker-desktop >/dev/null 2>&1
}

# Main script
if is_docker_process_active; then
    sleep 5
    if ! is_docker_desktop_active; then
        systemctl --user stop docker-desktop
    fi
    echo "%{B#3FFFFFFF}%{u#39949C}%{+u}  %{T3}%{T1}  %{-u}%{B-} "
else
    echo "%{B#0FFFFFFF}%{u#373B41}%{+u}  %{T3}%{T1}  %{-u}%{B-} "
fi

