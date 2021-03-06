#!/bin/sh

#
# Shfmt command:
#
# $ shfmt -i 2 -bn -ci <filename>
#

__GEPSH_REQARG="reqarg"
__GEPSH_NOARG="noarg"

#
# Checks the argument type of a given option.
# Globals:
#   __GEPSH_REQARG
#   __GEPSH_NOARG
# Arguments:
#   1: option without dashes, 2: option list.
# Outputs:
#   Writes, when successful, the argument type of the given option.
# Returns:
#   0 if the option was found, 1 if not.
#
__get_argtype() {
  #
  # The the first argument must comme stripped of dashes, because these function
  # doesn't know if it's checking against a short or long option.
  #
  # If the loop is broken, a match was found and the function returns 0; if
  # exhausted, the function returns 1.
  #

  __get_argtype_target="${1}"
  __get_argtype_list="${2}"
  __get_argtype_elem=""
  while [ -n "${__get_argtype_list}" ]; do
    #
    # The string deletions below are as follows:
    #
    # The first one deletes all but the first element of the passed list.
    #
    # The second one, the first element.
    #
    # The third, the comma after the first element. This deletion is done
    # separately, because of the last element: when it's reached, it contains no
    # ',' after itself, so adding a ',' to the pattern would cause it to not be
    # deleted and the loop to never finish. By separating the deletion of the
    # ',', the last item can be deleted.
    #
    __get_argtype_elem="${__get_argtype_list%%,*}"
    __get_argtype_list="${__get_argtype_list#"${__get_argtype_elem}"}"
    __get_argtype_list="${__get_argtype_list#,}"

    #
    # Comparison with The Target
    #
    # Since the passed options do not contain a ':' at the end, it must be
    # removed from the current element.
    #
    case "${__get_argtype_elem%:}" in
      "${__get_argtype_target}")
        [ -z "${__get_argtype_elem#*:}" ] \
          && printf "%s" "${__GEPSH_REQARG}" \
          || printf "%s" "${__GEPSH_NOARG}"
        return 0
        ;;
    esac
  done

  return 1
}

#
# Parse the given long option
# Globals:
#   __GEPSH_REQARG
#   __GEPSH_NOARG
# Arguments:
#   1: long option, 2: option list, 3: current arguments.
# Outputs:
#   STDOUT:
#     When successful, the number of argument to shift succeeded by a
#     ':', the escaped long option and, when there's one, the latter's argument
#     separated by a space (' ') and also escaped:
#
#       n:"--long-option" "long option argument"
#
#   STDERR:
#     An error message explaining the invalidity of the given option.
# Returns:
#   0 if the option was valid, 1 if not.
#
__lopt_parse() {
  __lopt_parse_opt="${1#--}"
  __lopt_parse_opt="${__lopt_parse_opt%%=*}"
  __lopt_parse_arg="${1#*=}"
  __lopt_parse_list="${2}"
  shift 2
  #
  # Fail on long options of length 1.
  #
  [ "${#__lopt_parse_opt}" -eq 1 ] && {
    printf "Long options must be of at least two characters length.\n" 1>&2
    return 1
  }

  #
  # Fail on invalid (not found) options.
  #
  __lopt_parse_argtype="$(
    __get_argtype "${__lopt_parse_opt}" "${__lopt_parse_list}"
  )" || {
    printf "Invalid long option -- \"--%s\".\n" "${__lopt_parse_opt}" 1>&2
    return 1
  }

  #
  # Case statements for each argument type.
  #
  case "${__lopt_parse_argtype}" in
    "${__GEPSH_NOARG}")
      #
      # An option that requires no argument was passed in the key=value format,
      # which is only for options that require arguments.
      #
      # This comparison works as follows: `${__lopt_parse_opt}` is stripped of
      # the double-dashes and of the `=value` part, if there's one;
      # `${__lopt_parse_arg}` is only `value`. Thus, when an argless option is
      # passed in the `key=value` format, these two variables will differ, since
      # the "${1%%=*}" string deletion will have caused a change.
      #
      # Remeber that, in any case, the former will lack the double dashes, and
      # so, they need to prefix it.
      #
      [ "--${__lopt_parse_opt}" != "${__lopt_parse_arg}" ] && {
        printf "Argless option with argument -- \"--%s=%s\".\n" \
          "${__lopt_parse_opt}" "${__lopt_parse_arg}"
        return 1
      }
      printf "0:\"--%s\"" "${__lopt_parse_opt}"
      ;;
    "${__GEPSH_REQARG}") ;;
  esac

  return 0
}

#
# Parse the given arguments.
# Globals:
#   None
# Arguments:
#   1: short option list, 2: long option list, 3: arguments.
# Outputs:
#   STDOUT:
#     When successful, the parsed arguments in a format for them to be given to
#     `eval set -- <stdout>`.
#   STDERR:
#     An error, message explaining the invalidity of the option.
# Returns:
#   0 when all arguments are parsed, 1 if one is invalid.
#
gepsh() {
  #
  # This function takes three arguments:
  #
  # gepsh "sopts" "lopts" "arguments"
  #
  # The first one is a comma separated list of one character strings that may
  # or not contain a ':' at the end --- e. g., "a,b:,c:", ---, which indicates
  # that the option takes an argument.
  #
  # The second one is also a comma separated list of strings with the
  # same idiosyncrasies, however, they must be more than one character of
  # length, for example, "a-long,b-long:,c-long:".
  #
  # Realize that for an option to be correctly parsed, both options must
  # indicate if it takes or not an argument. Moreover, spaces between the
  # options are not supported, hence, "a,b:,c" and "a-long,b-long:,c-long" are
  # valid, while "a , b:, c" and " a-long , b-long: , c-long" are not.
  #
  # If the program contains no short or long options, a comma should be passed
  # in their place:
  #
  # gepsh "," "a-long" "arguments"
  #
  # The last argument are the arguments to be parsed.
  #
  # Do note that that this implementation of an argument parser follows the
  # behavior of GNU Getopt with the `POSIXLY_CORRECT` environment variable set:
  # the first positional argument reached will make all of those after it to be
  # treated like positional arguments.
  #
  #sopts="${1}"
  gepsh_lopts="${2}"
  shift 2
  gepsh_treat_as_posargs=""

  #
  # This function only prints one time to stdout: after the loop, when all
  # options and arguments are correctly parsed. This is done to avoid mixing the
  # captured error message with validated arguments.
  #
  gepsh_stdout=""

  while [ "${#}" -gt 0 ]; do
    gepsh_parsed=""
    #
    # For info on this parameter expansion, see `Positional Arguments` below.
    #
    case "${gepsh_treat_as_posargs:-"${1}"}" in
      #
      # Long Options
      #
      # Even though these options must be at least two character long, the check
      # is done against options with the double dashes and a single char too.
      # Because of this, they can be invalidated.
      #
      --?*)
        #
        # Firstly, the double dashes are removed, since only the option name is
        # compared to check its validity; secondly, the argument preceded by a
        # '=' is removed: realize that, when the option is not passed in the
        # "key=value" format, such string deletion will do nothing.
        #
        gepsh_parsed="$(__lopt_parse "${1}" "${gepsh_lopts}" "${@}" 2>&1)" || {
          printf "gepsh: %s\n" "${gepsh_parsed}" 1>&2
          return 1
        }
        ;;
      #
      # Short Options
      #
      # To avoid that the special positional argument ("--") is caught here, the
      # [!-] is used after the first dash; with this the former may be excluded.
      # Moreover, a '*' is used instead of a '?' for this case to be able to
      # caught short options with either arguments --- e. g., "-aArgOfA" ---,
      # options --- e. g., "-abc" --- or both --- e. g., "-abcArgOfC" ---
      # conjoined to itself.
      #
      -[!-]*) ;;
      #
      # Positional Arguments
      #
      # Since this parser follows, partialy, the behavior of `GNU getopt` when
      # the `POSIXLY_CORRECT` variable is set, at the first positional argument,
      # all of the remaining ones, whatever they are, shall be considered also
      # positional arguments. Thus, the arguments:
      #
      # `-abc --d-long ArgOfD PosArg1 -efg --h-long=ArgOfH`
      #
      # would be divided in:
      #
      # 1) Optional arguments and its positional arguments:
      # `"-a" "-b" "-c" "--d-long" "ArgOfD"`
      #
      # 2) Positional arguments:
      # `"PosArg1" "-efg" "--h-long=ArgOfH"`
      #
      # To achieve this behavior, there must be a flag which is set when the
      # first positional argument is found.
      # Such a flag is `gepsh_treat_as_posargs`.
      #
      # Its use on the `WORD` argument of the case statement has the following
      # rationale: all that is not a long option (`--?*`) or a short option
      # (`-[!-]*`) is a positional argument, in consequence, the value `1` ---
      # `gepsh_treat_as_posargs` value when set --- will always be treated as an
      # positional argument.
      #
      # Realize that this matching does not alter the value of `${1}`, only the
      # `WORD` argument of the case statement.
      #
      *)
        #
        # When a program is looping over the parsed options, the "--" indicates
        # that, with it, the positional arguments begin.
        #
        [ -z "${gepsh_treat_as_posargs}" ] && {
          gepsh_stdout="$(printf "%s \"%s\"" "${gepsh_stdout}" "--")"
        }
        gepsh_stdout="$(printf "%s \"%s\"" "${gepsh_stdout}" "${1}")"
        gepsh_treat_as_posargs="1"
        ;;
    esac
    shift
  done
  #
  # In the case that no positional arguments were passed ---
  # `[ -z "${gepsh_treat_as_posargs}" ]` equals true --- a "--" must be appended
  # now, or else the scripts using this library would not be able to break the
  # loop
  #
  [ -z "${gepsh_treat_as_posargs}" ] && {
    printf "%s \"--\"\n" "${gepsh_stdout}"
    return 0
  }
  printf "%s\n" "${gepsh_stdout}"
}
