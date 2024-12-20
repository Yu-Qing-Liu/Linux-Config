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
alias catkin_mk='catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=YES && source devel/setup.bash && ln -s build/compile_commands.json compile_commands.json'
alias catkin_clean='catkin_make clean'

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
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"/home/admin/Applications/acados/lib"
export ACADOS_SOURCE_DIR="/home/admin/Applications/acados/"
export CC=clang
export CXX=clang++
export PATH="$HOME/.cargo/bin:$PATH"

# Sources
source /opt/ros/noetic/setup.bash
source "$HOME/.cargo/env"

PS1='[\u@\h \W]\$ '

# Start a ranger instance on each launch
ranger
. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
