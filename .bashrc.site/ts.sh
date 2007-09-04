# ts.sh

_bashrc_linux_style_prompt
add-ssh-agent() {
    local SOCK_CMD_FILE=~/.ssh/agent/${HOSTNAME}/sock
}

alias ssh=sSh

export LESSKEY="/u/aneitsch/.less"
export CVS_RSH='cvsssh'
export LD_LIBRARY_PATH="$HOME/usr/local/lib:/usr/pkg/lib"
export MANPATH="$MANPATH:/usr/pkg/man"
export JAVA_HOME="$HOME/usr/local/java/$ARCH"
# This is picked up by a custom .vimrc
export VIM_HIGHLIGHT_LONG_LINES=1
MANPATH="${MANPATH#:}"
MANPATH="${MANPATH%:}"

DOMAIN="$(hostname |egrep -o '[a-z]+.[a-z]+$')"
export http_proxy=http://proxy.${DOMAIN}:3128
export https_proxy=http://proxy.${DOMAIN}:3128
export ftp_proxy=http://proxy.${DOMAIN}:3128
export all_proxy=http://proxy.${DOMAIN}:3128
export no_proxy="localhost,127.0.0.1,*.${DOMAIN}"

# Limits
umask 002 # rwxrwxr-x
