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

: "${DISPLAY=:0}"
# Avoid race: the cookie has to be in place before starting the server
#
# PARANOIA: generating a cookie and passing it to ‘xauth add’ on the
# command line is insecure.
python -ES -c \
    "import os; print 'add ${DISPLAY} . %s' % os.urandom(16).encode('hex')" \
    | xauth source -
[ "${PIPESTATUS[0]}" -eq 0 ]

run /usr/X11R6/bin/Xwin_GL \
    -auth ~/.Xauthority \
    -multiwindow -clipboard -emulate3buttons -unixkill \
    -screen 0 2432x1064 "${DISPLAY}" &

MAX_CHECKS=50
CHECK=1
while ! [ -s "/tmp/.X11-unix/X${DISPLAY#:}" ] \
    &&[ "${CHECK}" -lt "${MAX_CHECKS}" ]
do
    (( CHECK++ ))
    sleep 0.1
done

export DISPLAY

. ~/.xinit
