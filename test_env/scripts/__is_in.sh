#!/bin/sh

#
# Shellcheck Global Directives
#
# Suppress warnings about sourced files:
# shellcheck source=/dev/null
#
# Suppress warnings about the time of expansion of a variable:
# shellcheck disable=SC2139
#

set -e

. "./${1}"
. "./${2}"
#
# These next statements are related to the helper.sh script (${2}).
#
export TESTNAME="__is_in() test"
alias rperr='helper_rperr'

#
# Global variables used in all tests.
__IS_IN_TARGET=""
__IS_IN_LIST=""
__IS_IN_ARG_TYPE=""
__IS_IN_REQARG="reqarg"
__IS_IN_NOARG="noarg"

#
# Short Options
#
# Test against a comma separated list of strings without ':'.
#
# The expected results are:
#
# 1) The "__IS_IN_ARG_TYPE" is set;
# 2) The set value of "__IS_IN_ARG_TYPE" is "noarg".
#
__IS_IN_TARGET="a"
__IS_IN_LIST="a,b,c"
__is_in_cmd() { __is_in "${__IS_IN_TARGET}" "${__IS_IN_LIST}"; }
__IS_IN_CMD="$(printf "__is_in \"%s\" \"%s\"" \
  "${__IS_IN_TARGET}" "${__IS_IN_LIST}")"
__IS_IN_ARG_TYPE="$(__is_in_cmd)" || {
  rperr "${C_TITLE}Short Option Test (Matching):${C_NORMAL} "
  TESTNAME="__HIDE__" rperr "${C_FAIL}FAILED${C_NORMAL}.\n"
  rperr "\"${C_TARGET}%s${C_NORMAL}\" was supposed to be found among " \
    "${__IS_IN_TARGET}"
  TESTNAME="__HIDE__" rperr "\"${C_TARGET}%s${C_LIST},%s${C_NORMAL}\".\n" \
    "${__IS_IN_TARGET}" "${__IS_IN_LIST#"${__IS_IN_TARGET},"}"
  rperr "${C_TITLE}Failed Command:${C_NORMAL}\n"
  TESTNAME="__HIDE__" rperr "\t${C_CMD}$ %s${C_NORMAL}\n" "${__IS_IN_CMD}"
  exit 1
}

[ "${__IS_IN_ARG_TYPE}" != "${__IS_IN_NOARG}" ] && {
  rperr "${C_TITLE}Short Option Test (Argument Type):${C_NORMAL} "
  TESTNAME="__HIDE__" rperr "${C_FAIL}FAILED${C_NORMAL}.\n"
  rperr "\"${C_TARGET}%s${C_NORMAL}\" was the expected output to stdout.\n" \
    "${__IS_IN_NOARG}"
  rperr "Instead got \"${C_FAIL}%s${C_NORMAL}\".\n" "${__IS_IN_ARG_TYPE}"
  rperr "${C_TITLE}Failed Command:${C_NORMAL}\n"
  TESTNAME="__HIDE__" rperr "\t${C_CMD}$ %s${C_NORMAL}\n" "${__IS_IN_CMD}"
  exit 1
}
