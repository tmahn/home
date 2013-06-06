import locale
import sys

if hasattr(sys, 'setdefaultencoding'):
    sys.setdefaultencoding(locale.getpreferredencoding().lower())
