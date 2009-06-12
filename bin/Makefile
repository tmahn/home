all: xdummyclient xterm7launcher

xterm7launcher: LDFLAGS += -mno-cygwin -mwindows -lws2_32

xdummyclient: LDFLAGS += -lX11

%: %.c
	${CC} ${CCFLAGS} $< -o $@ ${LDFLAGS}
