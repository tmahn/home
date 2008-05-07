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
