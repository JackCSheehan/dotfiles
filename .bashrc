# .bashrc

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

PS1="\[\e[0;92m\]\u@\h\[\e[m\]:\[\e[0;94m\]\w\[\e[m\]\\$ "

