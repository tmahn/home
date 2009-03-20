.DELETE_ON_ERROR:

SHELL = /bin/bash

X_SERVER_IS_X_WIN32 := $(shell if xdpyinfo | grep '^vendor string:.*StarNet Communications' > /dev/null; then echo true; else false; fi)

XKBCOMP      ?= $(shell if ${X_SERVER_IS_X_WIN32}; then echo X-Win32-xkbcomp; else echo xkbcomp; fi)
SETXKBMAP    ?= $(shell if ${X_SERVER_IS_X_WIN32}; then echo true; else echo setxkbmap; fi)

XKBCOMPFLAGS += -I.

xkbmap.xkm: neitsch.xkbsym

install: xkbmap.xkm
	${SETXKBMAP}
	${XKBCOMP} ${XKBCOMPFLAGS} "${<}" "${DISPLAY}"

%.xkbsym: %.klc
	klc2xkb --compose=XCompose.dead_keys "${<}" > "${@}"
%.xkm: %.xkb
	${XKBCOMP} ${XKBCOMPFLAGS} "${<}" -o "${@}"

clean:
	rm -f *.xkbsym *.xkm

OSTYPE := $(shell uname -o)
ifeq (${OSTYPE},Cygwin)

XKBCOMPFLAGS += -Icygxkb

# The cygwin X server comes with old files. We pull down the new ones so
# that the .xkb file from newer machines will work here too.
xkbmap.xkb: cygxkb
KEYBOARD_CONFIG_URL = http://gitweb.freedesktop.org/?p=xkeyboard-config.git;a=blob_plain;f=
cygxkb:
	mkdir -p cygxkb/symbols
	wget '${KEYBOARD_CONFIG_URL}symbols/pc' -O cygxkb/symbols/pc
	wget '${KEYBOARD_CONFIG_URL}symbols/keypad' -O cygxkb/symbols/keypad
endif

# diff does not like utf-16.
diff:
	diff -u \
	    <(iconv -f utf-16 -t utf-8 < .svn/text-base/neitsch.klc.svn-base) \
	    <(iconv -f utf-16 -t utf-8 < neitsch.klc)
