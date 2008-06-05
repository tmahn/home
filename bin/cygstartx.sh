#!/bin/sh
/usr/X11R6/bin/run Xwin_GL \
    -multiwindow -clipboard -emulate3buttons -unixkill

/usr/bin/sleep 5
export DISPLAY=:0

/usr/X11R6/bin/xset +fp /home/neitsch/.fonts
/usr/X11R6/bin/xrdb /home/neitsch/.Xresources
