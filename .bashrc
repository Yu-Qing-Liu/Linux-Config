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

# Environment variables
export SYSTEM_EDITOR=nvim
export EDITOR=nvim
export VISUAL=nvim
export LS_COLORS="$(vivid generate ~/.config/vivid/themes/kanagawa.yml)"
export TERM=wezterm nvim
export TEXINPUTS="/usr/share/texmf-dist/tex/latex:$TEXINPUTS"

PS1='[\u@\h \W]\$ '

# Start a ranger instance on each launch
ranger
