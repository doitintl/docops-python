# =============================================================================
# Make
# =============================================================================

.EXPORT_ALL_VARIABLES:

# ANSI formatting
BOLD = [1m
RESET = [0m

.DEFAULT_GOAL = help

define print-target-list
@ grep -E '^.PHONY:' $(MAKEFILE_LIST) | grep "#" | \
	sed -E "s,[^:]+: ([a-z-]+) # (.*),  \x1b$(BOLD)\1\x1b$(RESET)#\2," | \
	column -t -s '#'
endef

# Primary targets
# =============================================================================

# help
# -----------------------------------------------------------------------------

.PHONY: help # Print this help message and exit
help:
	@ printf '%s\n\n' "Usage: make [target]"
	@ printf '%s\n\n' 'Available targets:'
	$(call print-target-list)

# check
# -----------------------------------------------------------------------------

.PHONY: check # Run all integration checks
check: lint test

# lint
# -----------------------------------------------------------------------------

.PHONY: lint # Run all lint programs
lint:

# install
# -----------------------------------------------------------------------------

.PHONY: install # Install the project dependencies
install:
	poetry install

# test
# -----------------------------------------------------------------------------

.PHONY: test # Test the Python code
test: install
	poetry run docops >/dev/null


# Secondary targets
# =============================================================================

# black
# -----------------------------------------------------------------------------

lint: black
.PHONY: black
black:
	poetry run black --quiet --check .

# black
# -----------------------------------------------------------------------------

lint: isort
.PHONY: isort
isort:
	poetry run isort --profile black --check src

# pydocstyle
# -----------------------------------------------------------------------------

lint: pydocstyle
.PHONY: pydocstyle
pydocstyle:
	poetry run pydocstyle

# flake8
# -----------------------------------------------------------------------------

lint: flake8
.PHONY: flake8
flake8:
	poetry run flake8 src/**/*

# pylint
# -----------------------------------------------------------------------------

lint: pylint
.PHONY: pylint
pylint:
	poetry run pylint --output-format=colorized --score=n src

# vulture
# -----------------------------------------------------------------------------

lint: vulture
.PHONY: vulture
vulture:
	poetry run vulture src

# bandit
# -----------------------------------------------------------------------------

lint: bandit
.PHONY: bandit
bandit:
	poetry run bandit --quiet --recursive src

# dodgy
# -----------------------------------------------------------------------------

lint: dodgy
.PHONY: dodgy
dodgy:
	chronic poetry run dodgy

# pyroma
# -----------------------------------------------------------------------------

lint: pyroma
.PHONY: pyroma
pyroma:
	poetry run pyroma .
