SHELL := /bin/sh
LIB_FILE := gepsh
TEST_ENV := test_env
TEST_ENV_SCRIPT_DIR := $(TEST_ENV)/scripts
#
# Test Formating Variables
#
BO := \033[1m
NO := \033[m

.PHONY: all install uninstall test test_get_argtype

all:
	@printf "Available Targets Are as Follows:\n\n"
	@printf "$(BO)install$(NO):\t\t"
	@printf "install the library (yet to be implemented).\n"
	@printf "$(BO)uninstall$(NO):\t\t"
	@printf "uninstall the library (yet to be implemented).\n"
	@printf "$(BO)test$(NO):\t\t\t"
	@printf "execute all test scripts in \"$(TEST_ENV_SCRIPT_DIR)\".\n"
	@printf "$(BO)test_get_argtype$(NO):\t"
	@printf "execute \"$(TEST_ENV_SCRIPT_DIR)/__get_argtype.sh\".\n"
	@printf "$(BO)test_lopt_parse$(NO):\t"
	@printf "execute \"$(TEST_ENV_SCRIPT_DIR)/__get_argtype.sh\".\n"

test: test_get_argtype test_lopt_parse

test_get_argtype:
	$(SHELL) $(TEST_ENV_SCRIPT_DIR)/__get_argtype.sh

test_lopt_parse:
	$(SHELL) $(TEST_ENV_SCRIPT_DIR)/__lopt_parse.sh
