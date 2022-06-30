SHELL := /bin/sh
LIB_FILE := src/gepsh.sh
TEST_ENV := test_env
TEST_ENV_SCRIPT_DIR := $(TEST_ENV)/scripts

#
# Formating Variables
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
	@printf "$(BO)test-fmt$(NO):\t\t"
	@printf "tests the formatting of \"$(LIB_FILE)\"\n"
	@printf "\t\t\twith \"grep\" and \"shfmt\".\n"
	@printf "$(BO)test_get_argtype$(NO):\t"
	@printf "execute \"$(TEST_ENV_SCRIPT_DIR)/__get_argtype.sh\".\n"
	@printf "$(BO)test_lopt_parse$(NO):\t"
	@printf "execute \"$(TEST_ENV_SCRIPT_DIR)/__get_argtype.sh\".\n"

test: test_get_argtype test_lopt_parse test-fmt

test-fmt:
	grep '.\{81\}' $(LIB_FILE) 1>/dev/null 2>&1 && exit 1 || exit 0
	shfmt -i 2 -bn -ci -d $(LIB_FILE)

test_get_argtype:
	LIB_TO_SOURCE=$(LIB_FILE) $(SHELL) $(TEST_ENV_SCRIPT_DIR)/__get_argtype.sh

test_lopt_parse:
	LIB_TO_SOURCE=$(LIB_FILE) $(SHELL) $(TEST_ENV_SCRIPT_DIR)/__lopt_parse.sh
