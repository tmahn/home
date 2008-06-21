import os.path
import site
import sys

site.addsitedir(os.path.expanduser(
    '~/opt/python%s/lib/python%s/site-packages' % ((sys.version[:3],) * 2)))

def customize():
    """
    Remove entries from sys.path that contain an __init__.py; package
    directories can contain subpackages that clash with built-in module
    names.
    """

    for path in sys.path[:]:
        if os.path.isfile(os.path.join(path, '__init__.py')):
            sys.path.remove(path)

customize()

if sys.platform == 'cygwin':
    # Cygwin (newlib) currently only supports the 'C' locale
    # So we need to tell python that CODESET is not supported by
    # removing it from the _locale module
    import _locale
    lc_ctype = _locale.setlocale(_locale.LC_CTYPE, None)
    if lc_ctype == 'C':
        del _locale.CODESET

        import codecs
        import locale

        sys.stdin = codecs.getreader(locale.getpreferredencoding())(sys.stdin)
        sys.stdout = codecs.getreader(locale.getpreferredencoding())(sys.stdout)

import locale
sys.setdefaultencoding(locale.getpreferredencoding())
