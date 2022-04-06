"""Wrapper module for the `cspell` program"""


import sys

from .. import wrappers


# pylint: disable=too-few-public-methods
class CspellWrapper(wrappers.BaseWrapper):

    """Wrapper class for the `cspell` program"""

    _PROGRAM_NAME = "cspell"

    _CONFIG_FILE = ".cspell.json"

    def run(self):
        """Run the `cspell` program"""
        files = self._get_files()
        stdout, stderr, returncode = self._call(
            self._PROGRAM_NAME,
            "--color",
            "--no-progress",
            "--no-summary",
            "--config",
            self._CONFIG_FILE,
            *files
        )
        if returncode:
            sys.stdout.write(stdout)
            sys.stderr.write(stderr)
        return returncode
