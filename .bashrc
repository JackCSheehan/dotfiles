# .bashrc

# Source global definitions
#if [ -f /etc/bashrc ]; then
#    . /etc/bashrc
#fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

PS1="\e[0;92m\u@\h\e[m:\e[0;94m\w\e[m\\$ "

# Alias for Tmux emulated in vim.
function tmux() {
    cmd="vim -c \"Tmux $1\""
    eval "$cmd"
}


