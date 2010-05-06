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

def __readline_shim_setup():
    import atexit
    import imp
    import os
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
        paths = list(filter(lambda x: x != mod_dir, sys.path))

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

    # While we're here, enable persistent history
    readline = sys.modules['readline']
    HIST_FILE = os.path.join(os.getenv('HOME'), '.pyhist')
    if os.path.isfile(HIST_FILE):
        readline.read_history_file(HIST_FILE)
    atexit.register(lambda: readline.write_history_file(HIST_FILE))

    # this is for Mac OS which somehow uses libedit under the hood?!?
    readline.parse_and_bind("bind ^I rl_complete")

    # And getting all our hacks together -- clean up sys.path again
    import sitecustomize
    sitecustomize.customize()

# Bindings in this module leak through to the real readline, so we create
# only one with an unlikely name and remove it after.
__readline_shim_setup()
del __readline_shim_setup
