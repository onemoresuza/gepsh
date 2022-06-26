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
  . "${LIB_TO_SOURCE}"
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
  __lopt_parse "${lopt}" "${lopt_list}" "${args}" 1>/dev/null 2>&1
  assertFalse " ${IT}${test_title}${NO}\n\t${BO}${test_cmd}${NO}\n\t" "${?}"

  lopt="--y-long"
  lopt_list="a-long,b-long,c-long"
  args=""
  test_title="Test the validity of a long option not in the option list"
  test_cmd="\$ __lopt_parse \"${lopt}\" \"${lopt_list}\" \"${args}\""
  __lopt_parse "${lopt}" "${lopt_list}" "${args}" 1>/dev/null 2>&1
  assertFalse " ${IT}${test_title}${NO}\n\t${BO}${test_cmd}${NO}\n\t" "${?}"

  lopt="--a-long=ArgOfA"
  lopt_list="a-long:,b-long,c-long"
  args=""
  test_title="Test the validity of a long option in the key=value format"
  test_cmd="\$ __lopt_parse \"${lopt}\" \"${lopt_list}\" \"${args}\""
  __lopt_parse "${lopt}" "${lopt_list}" "${args}" 1>/dev/null 2>&1
  assertTrue " ${IT}${test_title}${NO}\n\t${BO}${test_cmd}${NO}\n\t" "${?}"

  lopt="--a-long=ArgOfA"
  lopt_list="a-long,b-long,c-long"
  args=""
  test_title="Test the validity of an argless long"
  test_title="${test_title} option in the key=value format"
  test_cmd="\$ __lopt_parse \"${lopt}\" \"${lopt_list}\" \"${args}\""
  __lopt_parse "${lopt}" "${lopt_list}" "${args}" 1>/dev/null 2>&1
  assertFalse " ${IT}${test_title}${NO}\n\t${BO}${test_cmd}${NO}\n\t" "${?}"

  return 0
}

. shunit2
