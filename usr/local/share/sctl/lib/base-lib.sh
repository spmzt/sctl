#!/bin/sh

OSKERNEL=$(uname -s)

to_lower() {
  echo $1 | tr '[:upper:]' '[:lower:]'
}

print_error() {
  local RED='\033[0;31m'
  local NC='\033[0m' # No Color
  printf "${RED}ERROR:\t$1${NC}\n"
}

number_validator() {
  case $1 in
  '' | *[!0-9]*)
    false
    ;;
  *)
    true
    ;;
  esac
}

force_run_as_root() {
  uid=$(id -u)
  if [ $uid != 0 ]; then
    print_error "Please run as \"root\" and try again."
    exit 1
  fi
}

usage() {
  cat <<EOF
sctl(8) is an open-source utility for automating deployment and management of
OSes.

Usage:
  sctl command [args]

Available Commands:
  jail   prepare and create jails

Use "sctl -v|--version" for version information.
Use "sctl command -h|--help" for more information about a command.

EOF
  exit 1
}
