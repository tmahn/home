#!/bin/sh

set -eu

PATH="/bin:/usr/X11R6/bin:${PATH}"
export PATH

DISPLAY=:0
# Avoid race: the cookie has to be in place before starting the server
xauth generate "${DISPLAY}" .
run /usr/X11R6/bin/Xwin_GL \
    -auth ~/.Xauthority \
    -multiwindow -clipboard -emulate3buttons -unixkill \
    -screen 0 2432x1064 &

MAX_CHECKS=50
CHECK=1
while ! [ -s "/tmp/.X11-unix/X0" ] \
    &&[ "${CHECK}" -lt "${MAX_CHECKS}" ]
do
    (( CHECK++ ))
    sleep 0.1
done

export DISPLAY

. ~/.xinit
