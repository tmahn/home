SHELL = /bin/bash

XKBCOMPFLAGS += -I.

xkbmap.xkm: neitsch.xkbsym

install: xkbmap.xkm
	setxkbmap
	xkbcomp "${<}" "${DISPLAY}"

%.xkbsym: %.klc
	klc2xkb --compose=XCompose.dead_keys "${<}" > "${@}"
%.xkm: %.xkb
	xkbcomp ${XKBCOMPFLAGS} "${<}" -o "${@}"

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
