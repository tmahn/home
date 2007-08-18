# ts.sh

_bashrc_linux_style_prompt

alias ssh=sSh

export LESSKEY="/u/aneitsch/.less"
export CVS_RSH='cvsssh'
export LD_LIBRARY_PATH="$HOME/usr/local/lib:/usr/pkg/lib"
export MANPATH="$MANPATH:/usr/pkg/man"
export JAVA_HOME="$HOME/usr/local/java/$ARCH"
MANPATH="${MANPATH#:}"
MANPATH="${MANPATH%:}"

# Limits
umask 002 # rwxrwxr-x
