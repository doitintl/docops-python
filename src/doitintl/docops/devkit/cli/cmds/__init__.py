"""Main CLI command"""

import click

from ... import cli
from ...core.app import Application


@click.group(cls=cli.StylizedGroup)
@click.help_option("-h", "--help", help=cli.HELP_STR)
@click.version_option("--version", help=cli.VERSION_STR, message="%(version)s")
@click.pass_context
def main(ctx):
    # noqa: D403
    """DoiT International DocOps Development Kit (DDK) CLI tool"""
    app = Application()
    ctx.obj = app


if __name__ == "__main__":
    # pylint: disable=no-value-for-parameter
    main()
