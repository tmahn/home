#!/bin/sh

set -eu

PATH="/bin:/usr/X11R6/bin:${PATH}"

run /usr/X11R6/bin/Xwin_GL \
    -multiwindow -emulate3buttons -unixkill \
    -screen 0 2432x1064 &

MAX_CHECKS=50
CHECK=1
while ! [ -s "/tmp/.X11-unix/X0" ] \
    &&[ "${CHECK}" -lt "${MAX_CHECKS}" ]
do
    (( CHECK++ ))
    sleep 0.1
done

export DISPLAY=:0

FONT_DIR=~/.fonts
if [ -d "${FONT_DIR}" ]; then
    xset +fp "${FONT_DIR}"
fi
xrdb ~/.Xresources
