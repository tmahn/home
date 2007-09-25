include ~/.Makefile

LIBS = findlib

all: ${LIBS:%=%.elc}

findlib.el: findlib.el.txt
	grep -A 1000 '\$$Id' $< |grep -B 1000 '^;;;.*ends here' > $@
findlib.el.txt:
	$(call usenextTextFromMessageID,wbrodie.286.0052E349@panix.com) > $@

#
clean:
	rm -f ${LIBS:%=%.el} ${LIBS:%=%.elc} ${LIBS:%=%.el.txt}
