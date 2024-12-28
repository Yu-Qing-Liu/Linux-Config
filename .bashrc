#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


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
export PATH=/home/admin/.local/bin:$PATH
export ACADOS_SOURCE_DIR="/home/admin/Applications/acados/"
export PATH="$HOME/.cargo/bin:$PATH"
export LD_LIBRARY_PATH=/usr/local/gcc-14.2.0/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"/home/admin/Applications/acados/lib"
export LD_LIBRARY_PATH=/home/admin/Applications/TensorRT-8.6.1.6/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
export CPLUS_INCLUDE_PATH=/home/admin/Repositories/AD/vcpkg/installed/x64-linux/include:$CPLUS_INCLUDE_PATH
export LIBRARY_PATH=/home/admin/Repositories/AD/vcpkg/installed/x64-linux/lib:$LIBRARY_PATH
export PKG_CONFIG_PATH=/home/admin/Repositories/AD/vcpkg/installed/x64-linux/lib/pkgconfig:$PKG_CONFIG_PATH
export CMAKE_PREFIX_PATH=/home/admin/Repositories/AD/vcpkg/installed/x64-linux:$CMAKE_PREFIX_PATH

# Sources
source /opt/ros/noetic/setup.bash
source "$HOME/.cargo/env"
source /home/admin/Repositories/AD/devel/setup.bash
source /home/admin/Repositories/Simulator/devel/setup.bash

PS1='[\u@\h \W]\$ '

# Cargo
. "$HOME/.cargo/env"

# Node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Hyprland
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec hyprland
fi
