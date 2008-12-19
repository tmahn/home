#!/bin/bash --login
#
# Script to start X on cygwin. Since this is launched from the Startup
# group, $HOME is likely empty and PATH might not contain any cygwin stuff.
# So the ‘--login’ on line 1 is important, but it seems that we can’t set
# ‘--noprofile’ too, because of a hack somewhere to make shebangs work for
# filenames on spaces.

set -eu

PATH="/bin:/usr/X11R6/bin:${PATH}"
export PATH

: "${DISPLAY=localhost:0.0}"
DISPLAY_NUMBER=":${DISPLAY##*:}"
DISPLAY_NUMBER="${DISPLAY_NUMBER%.*}"

XWIN=/usr/X11R6/bin/Xwin_GL
XRUN=run

if ! [ -x "${XWIN}" ]; then
    XWIN=/usr/bin/Xwin
fi

XMING="/d/c/Program Files (x86)/Xming/Xming.exe"
if [ -x "${XMING}" ]; then
    XWIN="${XMING}"
    XRUN="setsid"
fi

# Avoid race: the cookie has to be in place before starting the server
#
# PARANOIA: generating a cookie and passing it to ‘xauth add’ on the
# command line is insecure.
python -ES -c \
    "import os; print 'add ${DISPLAY} . %s' % os.urandom(16).encode('hex')" \
    | xauth source -
[ "${PIPESTATUS[0]}" -eq 0 ]

"${XWIN}" \
    -auth ~/.Xauthority \
    -multiwindow -clipboard -emulate3buttons -unixkill \
    -screen 0 2432x1064 "${DISPLAY_NUMBER}" &

export DISPLAY

function isDisplayUp() {
   xprop -root >& /dev/null 
}

MAX_CHECKS=50
CHECK=1
while ! isDisplayUp &&[ "${CHECK}" -lt "${MAX_CHECKS}" ]
do
    (( CHECK++ ))
    sleep 0.1
done
if ! isDisplayUp; then
    exit 1
fi

. ~/.xinit
