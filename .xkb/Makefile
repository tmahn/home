xkbmap.xkm: neitsch.xkb

install: xkbmap.xkm
	xkbcomp "${<}" "${DISPLAY}"

%.xkb: %.klc
	klc2xkb "${<}" > "${@}"
%.xkm: %
	xkbcomp "${<}"
