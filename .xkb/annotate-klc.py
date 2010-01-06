#!/usr/bin/env python

from __future__ import with_statement

import re
import sys
import unicodedata

deadkey_line = re.compile('[0-9A-Fa-f]{4}\s+[0-9A-Fa-f]{4}\s+//')

def rewrite(filename):
    contents = open(filename).read().decode('UTF-16')
    output = []
    for line in contents.split('\r\n'):
        match = deadkey_line.match(line)
        if match:
            output.append(line + " (" + unicodedata.name(line[-1]) + ")")
        else:
            output.append(line)
    with open(filename, 'wb') as outfile:
        outfile.write('\r\n'.join(output).encode('UTF-16'))

if __name__ == '__main__':
    rewrite(sys.argv[1])
