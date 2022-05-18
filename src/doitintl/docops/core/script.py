"""Script module"""

import os
import pathlib
import subprocess  # nosec B404
import sys

SCRIPTS_DIR = pathlib.Path(__file__).parent.parent / "scripts"


class Script:

    """Script class"""

    path = None
    name = None

    def __init__(self, path):
        """Initialize the script"""
        if not path.is_file():
            raise FileNotFoundError(f"{path} is not a file")
        self.path = path
        self.name = path.stem

    def __repr__(self):
        """Return a string representation of the script object"""
        return f"<Script {self.path}>"

    def run(self):
        """Call a script"""
        # Ensure a standard localization environment
        os.environ["LC_ALL"] = "C"
        with subprocess.Popen(  # nosec B603
            self.path,
            cwd=os.getcwd(),
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        ) as process:
            stdout, stderr = process.communicate()
            sys.stdout.write(stdout)
            sys.stderr.write(stderr)
            return process.returncode


class ScriptCollection:

    """Script collection class"""

    @staticmethod
    def list():
        """Return a list of available scripts"""
        scripts = [Script(path) for path in sorted(SCRIPTS_DIR.glob("*.sh"))]
        return list(scripts)

    @staticmethod
    def load(name):
        """Load a script"""
        return Script(SCRIPTS_DIR / f"{name}.sh")
