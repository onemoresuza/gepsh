#
# Shellcheck Global Directives
#
# Suppress warnings about using variables as format strings:
# shellcheck disable=SC2059
#

export C_TITLE="\033[1m\033[3m"
export C_CMD="\033[1m"
export C_FAIL="\033[38;5;160m"
export C_SUCCESS="\033[38;5;70m"
export C_TARGET="\033[38;5;226m"
export C_LIST="\033[38;5;26m"
export C_NORMAL="\033[m"

helper_rperr() {
  #
  # Report an error (${1} as the format string; ${@}, without ${1} as its
  # arguments) to stderr, preceded by "${TESTNAME}: ".
  #
  fmtstr="${1}"
  shift
  case "${TESTNAME}" in
    "__HIDE__")
      printf -- "${fmtstr}" "${@}" 1>&2
      ;;
    *)
      printf -- "%s${fmtstr}" \
        "${TESTNAME:-TESTNAME LACKS VALUE}: " "${@}" 1>&2
      ;;
  esac
}
