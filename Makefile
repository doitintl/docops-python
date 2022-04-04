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

# install
# -----------------------------------------------------------------------------

.PHONY: install # Install the project dependencies
install:
	poetry install

# check
# -----------------------------------------------------------------------------

.PHONY: check # Run the project checks
check:

# Secondary targets
# =============================================================================

# prospector
# https://prospector.landscape.io/en/master/
# -----------------------------------------------------------------------------

check: prospector
.PHONY: prospector
prospector:
	chronic poetry run prospector --messages-only
