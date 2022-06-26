#!/bin/sh
# file: test_env/scripts/__get_argtype.sh

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
  REQARG="reqarg"
  NOARG="noarg"
  . ./gepsh
}

oneTimeTearDown() {
  unset BO BI NO REQARG NOARG
}

tearDown() {
  unset test_title test_cmd str str_list
}

testMatching() {
  str="a"
  str_list="a,b,c"
  test_title="Matching test on argless short option:"
  test_cmd="\$ __get_argtype \"${str}\" \"${str_list}\""
  assertTrue " ${IT}${test_title}${NO}\n\t${BO}${test_cmd}${NO}" \
    "test $(__get_argtype "${str}" "${str_list}")"

  str="a"
  str_list="a:,b,c"
  test_title="Matching test on short option with argument:"
  test_cmd="\$ __get_argtype \"${str}\" \"${str_list}\""
  assertTrue " ${IT}${test_title}${NO}\n\t${BO}${test_cmd}${NO}" \
    "test $(__get_argtype "${str}" "${str_list}")"

  str="a-long"
  str_list="a-long,b-long,c-long"
  test_title="Matching test on argless long option:"
  test_cmd="\$ __get_argtype \"${str}\" \"${str_list}\""
  assertTrue " ${IT}${test_title}${NO}\n\t${BO}${test_cmd}${NO}" \
    "test $(__get_argtype "${str}" "${str_list}")"

  str="a-long"
  str_list="a-long:,b-long,c-long"
  test_title="Matching test on long option with argument:"
  test_cmd="\$ __get_argtype \"${str}\" \"${str_list}\""
  assertTrue " ${IT}${test_title}${NO}\n\t${BO}${test_cmd}${NO}" \
    "test $(__get_argtype "${str}" "${str_list}")"

  return 0
}

testArgTypeRecognition() {
  str="a"
  str_list="a,b,c"
  test_title="Argument type recognition test on argless short option:"
  test_cmd="\$ __get_argtype \"${str}\" \"${str_list}\""
  assertEquals " ${IT}${test_title}${NO}\n\t${BO}${test_cmd}${NO}\n\t" \
    "${NOARG}" "$(__get_argtype "${str}" "${str_list}")"

  str="a"
  str_list="a:,b,c"
  test_title="Argument type recognition test on short option with argument:"
  test_cmd="\$ __get_argtype \"${str}\" \"${str_list}\""
  assertEquals " ${IT}${test_title}${NO}\n\t${BO}${test_cmd}${NO}\n\t" \
    "${REQARG}" "$(__get_argtype "${str}" "${str_list}")"

  str="a-long"
  str_list="a-long,b-long,c-long"
  test_title="Argument type recognition test on argless long option:"
  test_cmd="\$ __get_argtype \"${str}\" \"${str_list}\""
  assertEquals " ${IT}${test_title}${NO}\n\t${BO}${test_cmd}${NO}\n\t" \
    "${NOARG}" "$(__get_argtype "${str}" "${str_list}")"

  str="a-long"
  str_list="a-long:,b-long,c-long"
  test_title="Argument type recognition test on long option with argument:"
  test_cmd="\$ __get_argtype \"${str}\" \"${str_list}\""
  assertEquals " ${IT}${test_title}${NO}\n\t${BO}${test_cmd}${NO}\n\t" \
    "${REQARG}" "$(__get_argtype "${str}" "${str_list}")"

  return 0
}

. shunit2
