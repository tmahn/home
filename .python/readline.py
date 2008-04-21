"""
HACK: When you run 'python -i', ${PYTHONSTARTUP} doesn't run, so there's no
chance to 'import rlcompleter', so tab completes for file names instead of
variable names, which is never what you want.

However, just before going interactive at the end of a script, python
imports readline. So this is a fake readline module to put earlier in
sys.path. It will find the real readline with the equivalent of a
dlsym(RTLD_NEXT), load it in place of itself, and then import rlcompleter.

You'd think that you could just put 'import rlcompleter' in
sitecustomize.py, but when readline is initialized it'll `tput smm` :/
"""

import imp
import sys
from os.path import abspath, dirname

def same_directory(path1, path2):
    path1 = abspath(dirname(path1))
    path2 = abspath(dirname(path2))
    return path1 == path2

def import_next(name, filename):
    """Import the next module 'name' in the search path that's not in the
    same directory as 'filename'."""

    paths = sys.path

    mod_dir = dirname(filename)
    paths = filter(lambda x: x != mod_dir, sys.path)

    while paths:
        real_module = imp.find_module(name, paths)
        new_filename = real_module[1]
        if same_directory(filename, new_filename):
            # In order not to fall into an infinite loop, drop the first
            # entry of path and try again.
            paths.pop(0)
        else:
            imp.load_module(name, *real_module)
            return

import_next(__name__, __file__)

import rlcompleter
