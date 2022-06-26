#!/bin/sh
# file: test_env/scripts/__lopt_parse.sh

#
# Shellcheck Global Directives
#
# Suppress warnings about not following files:
# shellcheck source=/dev/null
#

oneTimeSetUp() {
  BO="\033[1m"
  IT="\033[3m"
  NO="\033[m"
  . ./gepsh
}

oneTimeTearDown() {
  unset BO BI NO
}

tearDown() {
  unset test_title test_cmd lopt lopt_list args
}

testLoptValidity() {
  lopt="--a"
  lopt_list="a,b-long,c-long"
  args=""
  test_title="Test the validity of a long option of length 1"
  test_cmd="\$ __lopt_parse \"${lopt}\" \"${lopt_list}\" \"${args}\""
  assertFalse " ${IT}${test_title}${NO}\n\t${BO}${test_cmd}${NO}" \
    "test $(__lopt_parse "${lopt}" "${lopt_list}" "${args}" 2>/dev/null)"

  lopt="--y-long"
  lopt_list="a-long,b-long,c-long"
  args=""
  test_title="Test the validity of a long option not in the option list"
  test_cmd="\$ __lopt_parse \"${lopt}\" \"${lopt_list}\" \"${args}\""
  assertFalse " ${IT}${test_title}${NO}\n\t${BO}${test_cmd}${NO}" \
    "test $(__lopt_parse "${lopt}" "${lopt_list}" "${args}" 2>/dev/null)"

  return 0
}

. shunit2
