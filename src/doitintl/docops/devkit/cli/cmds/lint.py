"""Lint command"""

import sys

import click

from ... import cli
from ...runners.lint import LintRunner


@click.group(cls=cli.StylizedGroup, chain=True)
@click.help_option("-h", "--help", help=cli.HELP_STR)
@click.pass_context
def lint(ctx):
    """Lint group

    You can run commands in isolation or you can chain multiple commands
    together.
    """
    runner = LintRunner()
    ctx.obj = runner


@lint.command(cls=cli.StylizedCommand)
@click.help_option("-h", "--help", help=cli.HELP_STR)
@click.pass_obj
def cspell(runner):
    """Run the `cspell` program"""
    sys.exit(runner.cspell())


@lint.command(cls=cli.StylizedCommand)
@click.help_option("-h", "--help", help=cli.HELP_STR)
@click.pass_obj
# pylint: disable=invalid-name
def ec(runner):
    """Run the `ec` program"""
    sys.exit(runner.ec())
