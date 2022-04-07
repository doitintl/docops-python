"""CLI entrypoint"""

import shutil
import typing as t

import click

from doitintl import docops

HELP_STR = "Print this help message and exit"
VERSION_STR = "Print the program version number and exit"


class StylizedHelpFormatter(click.HelpFormatter):

    """Stylizes the formatting of text-based help pages"""

    def write_usage(self, *args, **kwargs):
        """Write a stylized usage line into the buffer"""
        prefix = kwargs.get("prefix", "Usage:")
        prefix = click.style(prefix, bold=True)
        super().write_usage(*args, prefix="")
        usage = self.getvalue()
        self.buffer = []
        usage = click.style(usage, italic=True)
        self.write(f"{prefix}\n\n  {usage}")

    def write_heading(self, heading):
        """Write a stylized heading into the buffer"""
        heading = click.style(f"{heading}:", bold=True)
        self.write(f"{'':>{self.current_indent}}{heading}\n\n")

    def write_dl(
        self,
        rows: t.Sequence[t.Tuple[str, str]],
        col_max: int = 30,
        col_spacing: int = 2,
    ):
        """Write a stylized definition list into the buffer"""
        new_rows = []
        for term, definition in rows:
            term = click.style(term, italic=True)
            new_rows.append((term, definition))
        super().write_dl(new_rows, col_max, col_spacing)


class StylizedContext(click.Context):

    """Adds stylized help formatting to the context object"""

    formatter_class = StylizedHelpFormatter


class StylizedCommand(click.Command):

    """Augments the stylized help formatting"""

    context_class = StylizedContext

    def _add_description(self, ctx, formatter):
        help_lines = self.help.strip().splitlines()
        if len(help_lines) > 1:
            heading = click.style("Description:", bold=True)
            formatter.write(f"\n{heading}\n")
            self.help = "\n".join(help_lines[2:])
            self.format_help_text(ctx, formatter)

    def format_help(self, ctx, formatter):
        """Write the augmented help into the formatter if it exists."""
        width = docops.DEFAULT_COLUMNS
        terminal_width = shutil.get_terminal_size().columns
        width = min(width, terminal_width)
        short_help = self.get_short_help_str(width)
        self.format_usage(ctx, formatter)
        formatter.write(f"\n  {short_help}\n")
        if self.help:
            self._add_description(ctx, formatter)
        self.format_options(ctx, formatter)
        self.format_epilog(ctx, formatter)


# pylint: disable=abstract-method
class StylizedMultiCommand(click.MultiCommand, StylizedCommand):

    """Mixes in the stylized help formatting"""


class StylizedGroup(click.Group, StylizedMultiCommand):

    """Mixes in the stylized help formatting"""

    context_class = StylizedContext
