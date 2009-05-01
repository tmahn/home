history -n
history -a

sudo -K

# Clear the screen if on a physical console
if [[ "$(tty)" =~ /tty[0-9]+$ ]]; then
    clear

    # Clear scrollback by reloading the default font
    setfont
fi
