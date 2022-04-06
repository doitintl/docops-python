"""Wrapper module"""

import shutil
import subprocess  # nosec B404


# pylint: disable=too-few-public-methods
class BaseWrapper:

    """Base wrapper class"""

    _PROGRAM_NAME = None

    _program_path = None

    def __init__(self):
        """Initialize the wrapper"""
        self._program_path = shutil.which(self._PROGRAM_NAME)

    @staticmethod
    def _call(*args, stdin=None):
        """Call a program"""
        with subprocess.Popen(  # nosec B603
            args,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        ) as process:
            stdout, stderr = process.communicate(stdin)
            returncode = process.returncode
            return stdout, stderr, returncode
