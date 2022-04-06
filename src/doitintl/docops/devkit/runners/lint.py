"""Lint runner module"""

from .. import runners
from ..wrappers import ec


# pylint: disable=too-few-public-methods
class LintRunner(runners.BaseRunner):

    """Core application class"""

    # pylint: disable=invalid-name
    @staticmethod
    def ec():
        """Run the `ec` program wrapper"""
        wrapper = ec.EcWrapper()
        return wrapper.run()
