# ~/.bash_profile: executed by bash for login shells.

if [ -e /etc/bash.bashrc ] ; then
  source /etc/bash.bashrc
fi

if [ -e ~/.bashrc ] ; then
  source ~/.bashrc
fi

# Set PATH so it includes user's private bin if it exists
# if [ -d ~/bin ] ; then
#   PATH="~/bin:${PATH}"
# fi

# Set MANPATH so it includes users' private man if it exists
# if [ -d ~/man ]; then
#   MANPATH="~/man:${MANPATH}"
# fi

# Set INFOPATH so it includes users' private info if it exists
# if [ -d ~/info ]; then
#   INFOPATH="~/info:${INFOPATH}"
# fi

