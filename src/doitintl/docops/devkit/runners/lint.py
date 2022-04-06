"""Lint runner module"""

from .. import runners
from ..wrappers import cspell, ec


# pylint: disable=too-few-public-methods
class LintRunner(runners.BaseRunner):

    """Core application class"""

    @staticmethod
    def cspell():
        """Run the `cspell` program wrapper"""
        wrapper = cspell.CspellWrapper()
        return wrapper.run()

    # pylint: disable=invalid-name
    @staticmethod
    def ec():
        """Run the `ec` program wrapper"""
        wrapper = ec.EcWrapper()
        return wrapper.run()
