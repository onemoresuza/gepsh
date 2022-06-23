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
export TESTNAME="__get_argtype() test"
alias rperr='helper_rperr'

#
# Global variables used in all tests.
#
__GET_ARGTYPE_TESTNAME=""
__GET_ARGTYPE_TARGET=""
__GET_ARGTYPE_LIST=""
__GET_ARGTYPE_ARG_TYPE=""
__GET_ARGTYPE_REQARG="reqarg"
__GET_ARGTYPE_NOARG="noarg"

#
# Functions
#
__get_argtype_err_on_matching() {
  #
  # Error message when there's no match.
  #
  rperr "${C_TITLE}%s (Matching):${C_NORMAL} " "${__GET_ARGTYPE_TESTNAME}"
  TESTNAME="__HIDE__" rperr "${C_FAIL}FAILED${C_NORMAL}.\n"
  rperr "\"${C_TARGET}%s${C_NORMAL}\" was supposed to be found among " \
    "${__GET_ARGTYPE_TARGET}"
  TESTNAME="__HIDE__" rperr "\"${C_LIST}%s${C_NORMAL}\".\n" \
    "${__GET_ARGTYPE_LIST}"
  rperr "${C_TITLE}Failed Command:${C_NORMAL}\n"
  TESTNAME="__HIDE__" rperr "\t${C_CMD}$ %s${C_NORMAL}\n" "${__GET_ARGTYPE_CMD}"
}

__get_argtype_err_on_argtype() {
  rperr "${C_TITLE}%s (Argument Type):${C_NORMAL} " "${__GET_ARGTYPE_TESTNAME}"
  TESTNAME="__HIDE__" rperr "${C_FAIL}FAILED${C_NORMAL}.\n"
  rperr "\"${C_TARGET}%s${C_NORMAL}\" was the expected output to stdout.\n" \
    "${__GET_ARGTYPE_NOARG}"
  rperr "Instead got \"${C_FAIL}%s${C_NORMAL}\".\n" "${__GET_ARGTYPE_ARG_TYPE}"
  rperr "${C_TITLE}Failed Command:${C_NORMAL}\n"
  TESTNAME="__HIDE__" rperr "\t${C_CMD}$ %s${C_NORMAL}\n" "${__GET_ARGTYPE_CMD}"
}

#
# Short Options Success Tests
#
__GET_ARGTYPE_TESTNAME="Short Options Success Tests"
#
# The following tests are supposed to succeed.
#
# Test against a comma separated list of strings without ':'.
#
# The expected results are:
#
# 1) The "__GET_ARGTYPE_ARG_TYPE" is set;
# 2) The set value of "__GET_ARGTYPE_ARG_TYPE" is "noarg".
#
__GET_ARGTYPE_TARGET="a"
__GET_ARGTYPE_LIST="a,b,c"
__get_argtype_cmd() { __get_argtype "${__GET_ARGTYPE_TARGET}" "${__GET_ARGTYPE_LIST}"; }
__GET_ARGTYPE_CMD="$(printf "__get_argtype \"%s\" \"%s\"" \
  "${__GET_ARGTYPE_TARGET}" "${__GET_ARGTYPE_LIST}")"
__GET_ARGTYPE_ARG_TYPE="$(__get_argtype_cmd)" || {
  __get_argtype_err_on_matching
  exit 1
}

[ "${__GET_ARGTYPE_ARG_TYPE}" != "${__GET_ARGTYPE_NOARG}" ] && {
  __get_argtype_err_on_argtype
  exit 1
}
#
# Test against a comma separated list of strings with ':'.
#
# The expected results are:
#
# 1) The "__GET_ARGTYPE_ARG_TYPE" is set;
# 2) The set value of "__GET_ARGTYPE_ARG_TYPE" is "reqarg".
#
__GET_ARGTYPE_TARGET="a"
__GET_ARGTYPE_LIST="a:,b,c"
__get_argtype_cmd() { __get_argtype "${__GET_ARGTYPE_TARGET}" "${__GET_ARGTYPE_LIST}"; }
__GET_ARGTYPE_CMD="$(printf "__get_argtype \"%s\" \"%s\"" \
  "${__GET_ARGTYPE_TARGET}" "${__GET_ARGTYPE_LIST}")"
__GET_ARGTYPE_ARG_TYPE="$(__get_argtype_cmd)" || {
  __get_argtype_err_on_matching
  exit 1
}

[ "${__GET_ARGTYPE_ARG_TYPE}" != "${__GET_ARGTYPE_REQARG}" ] && {
  __get_argtype_err_on_argtype
  exit 1
}

printf "%s: ${C_TITLE}%s:${C_NORMAL} ${C_SUCCESS}SUCCESS${C_NORMAL}.\n" \
  "${TESTNAME}" "${__GET_ARGTYPE_TESTNAME}"
