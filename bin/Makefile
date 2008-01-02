include ~/.Makefile

.PHONY: all
all: maketex \
     .arch-n-opsys

maketex:
	wget http://www1.maths.lth.se/help/latex/maketex/maketex
	chmod +x $@
	sed -e '1s,/usr/local/bin/bash,/bin/bash,g' -i $@

.arch-n-opsys:
	if ! which $@ >& /dev/null; then \
	    ln -s /usr/lib/smlnj/bin/.arch-n-opsys .; \
	fi
