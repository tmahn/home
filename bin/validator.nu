#!/usr/bin/env python2.7

import argparse
import sys

import requests

LOCAL = 'http://127.0.0.1:8888/'
REMOTE = 'http://validator.nu/'

def main(args=None):
    if args is None:
        args = sys.argv[1:]

    parser = argparse.ArgumentParser()
    parser.add_argument('--url', type=str, default=LOCAL)
    parser.add_argument('--local', action='store_const', dest='url',
                        const=LOCAL)
    parser.add_argument('--remote', action='store_const', dest='url',
                        const=REMOTE)
    parser.add_argument('--format', default='gnu',
                        choices=['', 'xhtml', 'xml', 'json', 'gnu', 'text'])
    parser.add_argument('file', type=argparse.FileType('r'))
    options = parser.parse_args(args)

    data = options.file.read()

    url = options.url + '?out=' + options.format

    r = requests.post(url, data=data, headers={'content-type': 'text/html'})
    validation = r.content.strip()

    retcode = 0
    if options.format == 'gnu' and validation:
        for line in validation.split('\n'):
            parts = line.split(':')
            if 'error' in parts[2]:
                retcode = 1
                break

        validation = '\n'.join(options.file.name + line
                               for line in validation.split('\n'))
    if validation:
        print validation

    sys.exit(retcode)

if __name__ == '__main__':
    sys.exit(main())
