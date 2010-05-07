# ~/.bashrc: executed by bash for interactive non-login shells

set +o allexport

# If this file is accidentally sourced multiple times, the next line will
# print a warning. Run bash --login -xv to get a dump.
readonly _HOME_BASHRC_ALREADY_READ=1

cd "${HOME}"

unalias -a

function check_exit_status ()
{
    local status="$?"
    local signal=""

    if [ ${status} -ne 0 -a ${status} != 128 ]; then
        # If process exited by a signal, determine name of signal.
        if [ ${status} -gt 128 ]; then
            signal="$(builtin kill -l $((${status} - 128)) 2>/dev/null)"
            if [ "$signal" ]; then signal="($signal)"; fi
        fi
        if [ -z "$signal" ]; then
            echo "Returned ${status}." 1>&2
        else
            echo "Returned ${status} ${signal}." 1>&2
        fi
    fi
    return 0
}

cd_func ()
{
  local x2 the_new_dir adir index
  local -i cnt

  if [[ $1 ==  "--" ]]; then
    dirs -v
    return 0
  fi

  set -- "$(echo "$1" |sed -e ':a
s@\.\.\.@../..@g
t a')"
  the_new_dir="$1"
  [[ -z "$1" ]] && the_new_dir="$HOME"

  if [[ ${the_new_dir:0:1} == '-' ]]; then
    #
    # Extract dir N from dirs
    index=${the_new_dir:1}
    [[ -z $index ]] && index=1
    adir=$(dirs +$index)
    [[ -z $adir ]] && return 1
    the_new_dir=$adir
  fi

  #
  # '~' has to be substituted by ${HOME}
  [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"

  #
  # Now change to the new dir and add to the top of the stack
  pushd "${the_new_dir}" > /dev/null
  [[ $? -ne 0 ]] && return 1
  the_new_dir=$(pwd)

  #
  # Trim down everything beyond 11th entry
  popd -n +15 2>/dev/null 1>/dev/null

  #
  # Remove any other occurence of this dir, skipping the top of the stack
  for ((cnt=1; cnt <= 10; cnt++)); do
    x2=$(dirs +${cnt} 2>/dev/null)
    [[ $? -ne 0 ]] && return 0
    [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
    if [[ "${x2}" == "${the_new_dir}" ]]; then
      popd -n +$cnt 2>/dev/null 1>/dev/null
      cnt=cnt-1
    fi
  done

  return 0
}

add-ssh-agent() {
    local SOCK_CMD_FILE=~/.ssh/agent/${HOSTNAME}/sock
    if [ -S "$SOCK_CMD_FILE" ]; then
        export SSH_AUTH_SOCK="$SOCK_CMD_FILE"
        # disabled by default so that a stray 'ssh-agent -k' won't bring
        # down the master ssh-agent
        # export SSH_AGENT_PID="$(<${SOCK_CMD_FILE%sock}pid)"
    elif [ -f "$SOCK_CMD_FILE" ] && [ -s "$SOCK_CMD_FILE" ]; then
        . "$SOCK_CMD_FILE"
    fi
}

## Aliases

alias erase=rm
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ls='ls -AF --color=auto'
alias import="echo \"You thought you were in a python shell, didn't you?\"
              false"

# builtins
alias cd=cd_func

# Use the real 'which'
if alias -p |grep -q '^alias which='
then
    unalias which
fi

## Variables for export
export LS_COLORS='no=00:fi=00:di=34:ln=36:pi=40;33:so=35:do=35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=32:*.tar=31:*.tgz=31:*.arj=31:*.taz=31:*.lzh=31:*.zip=31:*.z=31:*.Z=31:*.gz=31:*.bz2=31:*.deb=31:*.rpm=31:*.jpg=35:*.png=35:*.gif=35:*.bmp=35:*.ppm=35:*.tga=35:*.xbm=35:*.xpm=35:*.tif=35:*.png=35:*.mpg=35:*.avi=35:*.fli=35:*.gl=35:*.dl=35:'
export LSCOLORS="exgxfxdxcxdaDa"

unset LD_ASSUME_KERNEL
export EDITOR=vim
export VISUAL=vim
mkdir -p -m 700 ~/.vimtmp
mkdir -p -m 700 ~/misc/bak
export BLOCK_SIZE=1
export PAGER=less
export LESS='-iM -z-3'
if less --help |grep -q -- --mouse-support; then
    export LESS="${LESS} --mouse-support"
fi
MY_LESSKEY="${HOME}/.less"
if [ "${LESSKEY}" != "${MY_LESSKEY}" ]; then
    export SYSTEM_LESSKEY="${LESSKEY}"
fi
export LESSKEY="${MY_LESSKEY}"
if [ "${LESSKEY}key" -nt "${LESSKEY}" ]; then
   lesskey
fi
#export CONFIG_SITE="$HOME/.config.site"
export PERLDOC_PAGER="less -fr"
export PERL5LIB="$HOME/.perl/lib/perl5/site_perl/5.10"
export RI="--format bs"
export PYTHONSTARTUP=~/.pyrc
export PYTHONPATH=~/.python
unset LC_ALL
export LANG=en_CA.UTF-8
if [ -f ~/.locale/en_CA.UTF-8@iso8601/LC_TIME ]; then
    export LOCPATH=~/.locale
    export LC_TIME=en_CA.UTF-8@iso8601
fi
export SSL_CERT_DIR=~/.ssl
export CVS_RSH=ssh

if [ "${TERM}" != "cygwin" ]; then
    # nroff (a shell script) only looks for UTF-8 (all uppercase) in LC_ALL,
    # and then looks for utf-8 in LESSCHARSET
    export LESSCHARSET=utf-8
fi

if [ "$OSTYPE" = "cygwin" ]; then
    export SMLNJ_CYGWIN_RUNTIME=true
    export TEMP=/tmp
    export TMP="${TEMP}"
    PATH="${HOME}/bin:${HOME}/usr/bin:${PATH}"
fi

# For MacPorts
if [ -d "/opt/local/bin" ]; then
    export PATH=/opt/local/bin:/opt/local/sbin:$PATH
    export MANPATH="/opt/local/share/man:$MANPATH"
fi

PATH="${HOME}/bin:${PATH}"

# Personal time zone
PERSONAL_TZ="${HOME}/Andrew_Neitsch"
PERSONAL_TZC="${PERSONAL_TZ}.tzc"
if [ "${PERSONAL_TZ}" -nt "${PERSONAL_TZC}" ] \
    && type -p personaltz > /dev/null
then
    personaltz "${PERSONAL_TZ}"
fi
if [ -f "${PERSONAL_TZC}" ]; then
    export TZ="${PERSONAL_TZC}"
fi


## Shell settings

shopt -s cdspell checkwinsize dotglob checkhash

# Limits
umask 022 # rw-r--r--

# Prompt
PROMPT_COMMAND=check_exit_status

# Misc
MAILCHECK=-1

## Terminal

# Are we on a terminal?
if [ -t 0 ];
then
    stty sane
    stty stop ''
    stty start ''
    stty werase ''
fi

case "${TERM}" in
    # http://nion.modprobe.de/blog/archives/572-less-colors-for-man-pages.html
    xterm-256color)
            export LESS_TERMCAP_md=$'\e[35m'
            export LESS_TERMCAP_us=$'\e[38;5;19m'
            export LESS_TERMCAP_ue=$'\e[0m'
            ;;

    xterm*)
	    export LESS_TERMCAP_md=$'\e[35m';;
    dumb)
	    # The default cygwin prompt sets the xterm title, which gets
	    # mangled in xemacs shell mode.
	    PS1="${PS1#\\[\\e\]0;\\w\\a\\\]}";;
esac


# For site-specific customizations, we map hostnames to 'sites', and then
# source ~/.bashrc.site/$site
#
# Site-specific files may want to use functions defined here.
function _bashrc_linux_style_prompt() {
    PS1="${HOSTNAME%.*.*}"':\w>'
    case "${LOGNAME}" in
        *neitsch) ;;
        *) PS1='\u@'"${PS1}" ;;
    esac
    # Xterm titles
    case "${TERM}" in
        xterm*)
        PS1="\[\e[94m\]${PS1}\[\e[0m\]\[\033]0;"
        PS1="${PS1}\$(date \"+%b %e %H:%M\") ${THEHOST}: \w\007\]"
        if [ "x${LOGNAME}" = "xroot" ]
        then
            PS1="\[\e[48;5;201m\]${PS1}\[\e[0m\] "
        fi;;
    esac
}

function _bashrc_clean_path() {
    # Given the name of a variable that contains a colon-separated list,
    # remove duplicates and blanks from that list and export it.
    eval local PATHTOCLEAN="\${${1}}"
    PATHTOCLEAN="$(echo -n "${PATHTOCLEAN}" | awk '
            BEGIN	  		{ RS = ":" }
            !seen[$0] && $0 != "" 	{ seen[$0] = 1;
                                          printf("%s:", $0)}')"
    PATHTOCLEAN="${PATHTOCLEAN%:}"
    eval export "${1}=\${PATHTOCLEAN}"
}

function _handle_site() {
    local SITE="$1"
    local SITE_FILE="${HOME}/.bashrc.site/$SITE.sh"
    if [ -n "$SITE" ] && [ -r "$SITE_FILE" ]; then
        . "$SITE_FILE"
    fi
}

if [ "${OSTYPE#linux}" != "${OSTYPE}" ]; then
    _handle_site linux
fi
if [ "${OSTYPE#darwin}" != "${OSTYPE}" ]; then
    _bashrc_linux_style_prompt
fi
if [ -e "${HOME}/ts" ]; then
    _handle_site ts
fi
if [ -e "${HOME}/cs.ualberta.ca" ]; then
    _handle_site cs.ualberta.ca
fi

_bashrc_clean_path PATH
# A blank entry seems to mean “use defaults too”
#_bashrc_clean_path MANPATH
_bashrc_clean_path INFOPATH
_bashrc_clean_path LD_LIBRARY_PATH

# History settings
HISTFILE=~/.bash_history
HISTSIZE=10000000
HISTFILESIZE=${HISTSIZE}
HISTIGNORE=ignorespace
HISTTIMEFORMAT="%s "
# I type exclamation marks in strings more often than I use the ! history
# command, so place the history command on something unlikely to be typed.
histchars=$'\177^#'
export -n HISTFILE HISTSIZE HISTFILESIZE HISTIGNORE HISTTIMEFORMAT

case "${OSTYPE}" in darwin*)
	alias ls='ls -AFG'
	;;
esac

# Needs to be last command in file
#
# DO NOT ADD ANYTHING AFTER THIS
set -o history
