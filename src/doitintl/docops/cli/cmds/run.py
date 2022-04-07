"""Lint command"""

import sys

import click

from ... import cli
from ...core.script import ScriptCollection


@click.group(cls=cli.StylizedGroup)
@click.help_option("-h", "--help", help=cli.HELP_STR)
@click.pass_context
def run(ctx):
    """Run scripts

    You can run commands in isolation or you can chain multiple commands
    together.
    """
    collection = ScriptCollection()
    ctx.obj = collection


def add_docstring(text):
    """Return a decorator that adds a docstring to a function"""

    def _doc(func):
        func.__doc__ = text
        return func

    return _doc


def add_command(cls, name):
    """Generate a command"""

    @click.command(cls=cli.StylizedCommand)
    @click.help_option("-h", "--help", help=cli.HELP_STR)
    @click.pass_obj
    @add_docstring(f"Run the {name} script")
    def generated_command(collection):
        """Run a generated command"""
        script = collection.load(name)
        sys.exit(script.run())

    cls.add_command(generated_command, name=name)


def add_commands(cls):
    """Generate a group of commands from the script collection"""
    for script in ScriptCollection.list():
        add_command(cls, script.name)


add_commands(run)
