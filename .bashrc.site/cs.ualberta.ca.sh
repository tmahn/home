for V in CFLAGS CXXFLAGS; do
    eval ${V}="\${$V/ -Warray-bounds/}"
    eval ${V}="\${$V/ -ftree-vrp/}"
done

MANPATH="${MANPATH}:/usr/local/man:/usr/share/man:/usr/kerberos/man"
