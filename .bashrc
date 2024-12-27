#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Start window manager
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec hyprland
fi

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias vim='nvim'
alias ranger='. ranger'

# Environment variables
export LANG=en_US.UTF-8
export SYSTEMD_EDITOR=nvim
export EDITOR=nvim
export VISUAL=nvim
export LS_COLORS="$(vivid generate ~/.config/vivid/themes/kanagawa.yml)"
export TEXINPUTS="/usr/share/texmf-dist/tex/latex:$TEXINPUTS"

PS1='[\u@\h \W]\$ '
