"""Main command"""

import click

from ... import cli
from . import script


@click.group(cls=cli.StylizedGroup)
@click.help_option("-h", "--help", help=cli.HELP_STR)
@click.version_option("--version", help=cli.VERSION_STR, message="%(version)s")
def main():
    # noqa: D403
    """DoiT International DocOps CLI program"""


main.add_command(script.run)

if __name__ == "__main__":
    # pylint: disable=no-value-for-parameter
    main()
