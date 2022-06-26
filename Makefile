SHELL := /bin/sh
LIB_FILE := gepsh
TEST_ENV := test_env
TEST_ENV_SCRIPT_DIR := $(TEST_ENV)/scripts

.PHONY: all install uninstall

all:
	@echo "Available Targets Are as Follows:\n"
	@echo "install: install the library (yet to be implemented)."
	@echo "uninstall: uninstall the library (yet to be implemented)."
