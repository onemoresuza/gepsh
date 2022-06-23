SHELL := /bin/sh
LIB_FILE := gepsh
TEST_ENV := test_env
TEST_ENV_SCRIPT_DIR := $(TEST_ENV)/scripts
TEST_ENV_HELPER_SCRIPT := $(TEST_ENV_SCRIPT_DIR)/helper.sh

.PHONY: all install uninstall test test-__get_argtype

all:
	@echo "Available Targets Are as Follows:\n"
	@echo "install: install the library (yet to be implemented)."
	@echo "uninstall: uninstall the library (yet to be implemented)."
	@echo "test: run all the tests."
	@echo "test-__is_in: run the test for the \"__is_in()\" function."

test: test-__get_argtype

test-__get_argtype:
	$(SHELL) $(TEST_ENV_SCRIPT_DIR)/__get_argtype.sh $(LIB_FILE) $(TEST_ENV_HELPER_SCRIPT)
