# .bashrc
#
# Use "man initfiles" for more documentation.
# Do not take the following lines out unless you're really sure of
# what you are doing.

# If this file is accidentally sourced multiple times, the next line will
# print a warning. Run bash --login -xv to get a dump.
readonly _HOME_BASHRC_ALREADY_READ=1

defaultsdir=/usr/local/lib/initfiles
if [ -r "$defaultsdir/system-bashrc" ]; then
   source "$defaultsdir/system-bashrc"
fi

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

  set -- "$(echo $1 |sed -e ':a;s/\.\.\./\.\.\/\.\./g;t a')"
  the_new_dir=$1
  [[ -z $1 ]] && the_new_dir=$HOME

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

## FUCK!
# Replace default completion routine because it keeps trying to add '.d' to
# everything
function _cd_ () 
{ 
    local c=${COMP_WORDS[COMP_CWORD]};
    local s g=0;
    local IFS='
';
    shopt -q extglob && g=1;
    test $g -eq 0 && shopt -s extglob;
    case "$(complete -p $1)" in 
        mkdir)

        ;;
        *)
            s="-S/"
        ;;
    esac;
    case "$c" in 
        \$\(*\))
            eval COMPREPLY=(${c})
        ;;
        \$\(*)
            COMPREPLY=($(compgen -c -P '$(' -S ')'	-- ${c#??}))
        ;;
        \`*\`)
            eval COMPREPLY=(${c})
        ;;
        \`*)
            COMPREPLY=($(compgen -c -P '\`' -S '\`' -- ${c#?}))
        ;;
        \$\{*\})
            eval COMPREPLY=(${c})
        ;;
        \$\{*)
            COMPREPLY=($(compgen -v -P '${' -S '}'	-- ${c#??}))
        ;;
        \$*)
            COMPREPLY=($(compgen -v -P '$' $s	-- ${c#?}))
        ;;
        \~*/*)
            COMPREPLY=($(compgen -d $s		-- "${c}"))
        ;;
        \~*)
            COMPREPLY=($(compgen -u $s		-- "${c}"))
        ;;
    esac;
    case "$1" in 
        mkdir)
            if test "$c" != "." -a "$c" != ".."; then
                #for x in $(compgen -f -S .d -- "${c%.}");
                for x in $(compgen -f -- "${c%.}");
                do
                    if test -d "${x}" -o -d "${x%.d}"; then
                        continue;
                    fi;
                    COMPREPLY=(${COMPREPLY[@]} ${x});
                done;
            fi
        ;;
    esac;
    test $g -eq 0 && shopt -u extglob
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
alias md='mkdir'
alias ls='ls -AF --color=auto'
alias view='vim -R'

# builtins
alias cd=cd_func

# Use the real 'which'
if alias -p |grep -q '^alias which='
then
    unalias which
fi

## Variables for export
export LS_COLORS='no=00:fi=00:di=34:ln=36:pi=40;33:so=35:do=35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=32:*.tar=31:*.tgz=31:*.arj=31:*.taz=31:*.lzh=31:*.zip=31:*.z=31:*.Z=31:*.gz=31:*.bz2=31:*.deb=31:*.rpm=31:*.jpg=35:*.png=35:*.gif=35:*.bmp=35:*.ppm=35:*.tga=35:*.xbm=35:*.xpm=35:*.tif=35:*.png=35:*.mpg=35:*.avi=35:*.fli=35:*.gl=35:*.dl=35:'

unset LD_ASSUME_KERNEL
export EDITOR=vim
export VISUAL=vim
export BLOCK_SIZE=1
export LESS='-iM -z-2'
export CONFIG_SITE="$HOME/.config.site"
export PERLDOC_PAGER="less -r"
export RI="--format bs"
export CFLAGS='-Wall -lm'
export CC='gcc'
export PYTHONSTARTUP=~/.pyrc
export LC_ALL=en_CA.utf-8 # C
if [ "$OSTYPE" = "cygwin" ]; then
    export SMLNJ_CYGWIN_RUNTIME=true
fi

## Shell settings

shopt -s cdspell checkwinsize dotglob checkhash

# Limits
umask 022 # rw-r--r--

# Prompt
THEHOST="${HOSTNAME}"
if [ "x${THEHOST:$((${#THEHOST}-4)):${#THEHOST}}" = "x.com" ]; then
  THEHOST="${THEHOST%.*.*}"
fi

PROMPT_COMMAND=check_exit_status

# Misc
MAILCHECK=-1

## Terminal

# Are we on a terminal?
if [ -t 0 ];
then
    stty sane
fi

if [ "${TERM}" = "xterm" ]; then
    # http://nion.modprobe.de/blog/archives/572-less-colors-for-man-pages.html
    export LESS_TERMCAP_md=$'\e[38;5;54m'
fi


# For site-specific customizations, we map hostnames to 'sites', and then
# source ~/.bashrc.site/$site
#
# Site-specific files may want to use functions defined here.
function _bashrc_linux_style_prompt() {
    PS1='\u@${THEHOST}:\w>'
    # Xterm titles
    if [ "x${TERM}" = "xxterm" ]
    then
        PS1="\[\e[94m\]${PS1}\[\e[0m\]\[\033]0;"
        PS1="${PS1}\$(date \"+%b %e %H:%M\") ${THEHOST}: \w\007\]"
        if [ "x${LOGNAME}" = "xroot" ]
        then
            PS1="\[\e[48;5;201m\]${PS1}\[\e[0m\] "
        fi
    fi
}
function _handle_site() {
    local SITE="$1"
    local SITE_FILE="${HOME}/.bashrc.site/$SITE.sh"
    if [ -n "$SITE" ] && [ -r "$SITE_FILE" ]; then
        . "$SITE_FILE"
    fi
}
case "${HOSTNAME}" in
    *.twosigma.com)
        _handle_site ts;;
    QZmaImLpJdfVhBzQ|*)
        ;;
esac

# History settings
HISTFILE=~/.bash_history
HISTSIZE=10000000
HISTFILESIZE=${HISTSIZE}
HISTIGNORE=ignorespace

# Needs to be last command in file
#
# DO NOT ADD ANYTHING AFTER THIS
set -o history
