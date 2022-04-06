"""Wrapper module for the `ec` program"""


import sys

from .. import wrappers


# pylint: disable=too-few-public-methods
class EcWrapper(wrappers.BaseWrapper):

    """Wrapper class for the `ec` program"""

    _PROGRAM_NAME = "ec"

    def run(self):
        """Run the `ec` program"""
        stdout, stderr, returncode = self._call(self._PROGRAM_NAME)
        if returncode:
            sys.stdout.write(stdout)
            sys.stderr.write(stderr)
        return returncode
