include ~/.Makefile

LIBS = findlib \
       session \
       xterm-title \
       xterm-frobs

all: ${LIBS:%=%.elc}

findlib.el: findlib.el.txt
	grep -A 1000 '\$$Id' $< |grep -B 1000 '^;;;.*ends here' > $@
findlib.el.txt:
	$(call usenextTextFromMessageID,wbrodie.286.0052E349@panix.com) > $@

SESSION_VERSION = 2.2a
# This mess is ugly but it works. If there are more packages with the same
# structure later, we can clean it up and generify it.
SESSION_URL = http://downloads.sourceforge.net
SESSION_URL = ${SESSION_URL}/emacs-session/session-${SESSION_VERSION}.tar.gz
session-${SESSION_VERSION}.tar.gz:
	wget ${SESSION_URL}
session.el: session-${SESSION_VERSION}.tar.gz
	tar -x session/lisp/$@ --strip-components=2 -f $<
	touch $@

FRIEDMAN_URL = http://www.splode.com/~friedman/software/emacs-lisp/src
xterm-title.elc: xterm-frobs.el
xterm-title.elc: BYTE_COMPILE_ARGS += -load xterm-frobs.el
xterm-title.el: URL = ${FRIEDMAN_URL}/xterm-title.el
xterm-frobs.el: URL = ${FRIEDMAN_URL}/xterm-frobs.el

%.el:
	wget ${URL}

#
clean:
	rm -f ${LIBS:%=%.el} ${LIBS:%=%.elc} ${LIBS:%=%.el.txt}
