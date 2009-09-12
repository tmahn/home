_bashrc_linux_style_prompt
ARCH="$(arch)"
export ARCH
PATH="${HOME}/bin:${HOME}/bin/linux:${HOME}/usr/arch/${ARCH}/bin\
:${HOME}/usr/bin\
:${HOME}/opt/python2.5/bin\
:/usr/local/bin:/usr/bin:/bin\
:${HOME}/usr/arch/${ARCH}/sbin\
:/usr/local/sbin:/usr/sbin:/sbin\
:${PATH}"
MANPATH="${HOME}/usr/share/man:${MANPATH}"
INFOPATH="${HOME}/usr/share/info:/usr/share/info:${INFOPATH}"
LD_LIBRARY_PATH="${HOME}/usr/arch/${ARCH}/lib:${LD_LIBRARY_PATH}"
