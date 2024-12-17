# ~/.bash_profile

# Set up the default PATH if necessary
export PATH="$HOME/bin:/usr/local/bin:$PATH"

# Set up some useful aliases (you can modify these)
alias ll="ls -l"
alias la="ls -la"

# Ensure the terminal prompt is friendly
export PS1="\u@\h:\w$ "

# Source .bashrc if it exists (optional but common)
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
. "$HOME/.cargo/env"
