_bashrc_linux_style_prompt
ARCH="$(arch)"
PATH="${HOME}/bin:${HOME}/bin/linux:${HOME}/usr/arch/${ARCH}/bin:${PATH}"
MANPATH="${HOME}/usr/share/man:${MANPATH}"
LD_LIBRARY_PATH="${HOME}/usr/arch/${ARCH}/lib:${LD_LIBRARY_PATH}"
