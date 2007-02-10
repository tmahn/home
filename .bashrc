# User dependent .bashrc file

# See man bash for more options...
  # Don't wait for job termination notification
  # set -o notify

  # Don't use ^D to exit
  # set -o ignoreeof

  # Don't put duplicate lines in the history.
  # export HISTCONTROL=ignoredups

# Some example alias instructions
# alias less='less -r'
# alias rm='rm -i'
# alias whence='type -a'
alias ls='ls -AF --color=auto'
#--color=tty
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
# alias ll='ls -l'
# alias la='ls -A'
# alias l='ls -CF'
alias cp='cp -p'

# Some example functions
# function settitle() { echo -n "^[]2;$@^G^[]1;$@^G"; }

#export DISPLAY='127.0.0.1:0.0'

export PATH=$HOME/bin:$PATH
export BLOCK_SIZE=1
export LESS=-M
export VISUAL=vim
#export CVSROOT=/usr/local/cvsroot

export PYTHONSTARTUP=~/.pyrc

LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jpg=01;35:*.png=01;35:*.gif=01;35:*.bmp=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.png=01;35:*.mpg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:';
export LS_COLORS

prompt_func() {
  v=$?
  [ $v != 0 ] && echo Returned $v. 1>&2
}
PROMPT_COMMAND=prompt_func

#alias cp='cp -p'
