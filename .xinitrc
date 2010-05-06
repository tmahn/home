set +e

FONT_DIR=~/.fonts
if [ -d "${FONT_DIR}" ]; then
    #  Xming needs windows paths
    if [ "$OSTYPE" = "cygwin" ] && xdpyinfo |grep -q 'Colin Harrison'; then
        FONT_DIR="$(cygpath -w "${FONT_DIR}")"
    fi
    xset +fp "${FONT_DIR}"
fi

xset b off # shitcan the freaking bell
xrdb ~/.Xresources
xsetroot -solid grey

case "${OSTYPE}" in
    linux*)
        make -C ~/.xkb install

        exec gnome-session
        ;;
    darwin*)
        exec /bin/sh /usr/X11/lib/X11/xinit/xinitrc
        ;;
esac
