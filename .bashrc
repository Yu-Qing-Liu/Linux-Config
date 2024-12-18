#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec startx
fi

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias vim='nvim'
alias ranger='. ranger'
alias pacman='pacman.sh'

# Environment variables
export LANG=en_US.UTF-8
export SYSTEMD_EDITOR=nvim
export EDITOR=nvim
export VISUAL=nvim
export LS_COLORS="$(vivid generate ~/.config/vivid/themes/kanagawa.yml)"
export TEXINPUTS="/usr/share/texmf-dist/tex/latex:$TEXINPUTS"
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/home/admin/Applications/TensorRT-8.2.5.1/lib:$LD_LIBRARY_PATH
export PATH=/home/admin/.local/bin:$PATH

# Sources
source /opt/ros/noetic/setup.bash

PS1='[\u@\h \W]\$ '

# Start a ranger instance on each launch
ranger
