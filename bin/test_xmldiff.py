import os
import py.test
import subprocess
import tempfile

from blindrut.os import (unix_pipe, process_substitute,
        with_temporary_file_containing)

def compare_xml(text1, text2, expected_diff):
    ret = with_temporary_file_containing(
            lambda f1: with_temporary_file_containing(
                lambda f2: unix_pipe(['xmldiff', '-U', '0',
                    '--label', '', '--label', '', f1, f2], '',
                    raise_on_error=False), text2), text1)
    leader = '--- \n+++ \n@@ '
    if ret.startswith(leader):
        ret = '\n'.join(ret.split('\n')[3:])
    assert ret == expected_diff

def test_1():
    test_xml = "<xml><bar/></xml>\n"
    compare_xml(test_xml, test_xml, "")

    test_xml2 = "<xml>  <bar>foo</bar></xml>\n"
    compare_xml(test_xml, test_xml2, """\
-  <bar/>
+  <bar>foo</bar>
""")

def test_failure():
    assert py.test.raises(subprocess.CalledProcessError,
            lambda: unix_pipe(['xmldiff', '/dev/null', '/dev/null']))
