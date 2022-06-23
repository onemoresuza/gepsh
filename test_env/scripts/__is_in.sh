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
# Short Options
#
# Test against a comma separated list of strings without ':' or trailing spaces.
#
__IS_IN_TARGET="a"
__IS_IN_LIST="a,b,c"
__is_in "${__IS_IN_TARGET}" "${__IS_IN_LIST}" || {
  rperr "${C_TITLE}Short Option Test:${C_NORMAL} "
  TESTNAME="__HIDE__" rperr "${C_FAIL}FAILED${C_NORMAL}.\n"
  rperr "\"${C_TARGET}%s${C_NORMAL}\" was supposed to be found among " \
    "${__IS_IN_TARGET}"
  TESTNAME="__HIDE__" rperr "\"${C_TARGET}%s${C_LIST},%s${C_NORMAL}\".\n" \
    "${__IS_IN_TARGET}" "${__IS_IN_LIST#"${__IS_IN_TARGET},"}"
  rperr "${C_TITLE}Failed Command:${C_NORMAL}\n"
  TESTNAME="__HIDE__" rperr "\t${C_CMD}$ __is_in \"%s\" \"%s\"${C_NORMAL}\n" \
    "${__IS_IN_TARGET}" "${__IS_IN_LIST}"
  exit 1
}
