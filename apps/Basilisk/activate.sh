# !/usr/bin/env bash

# NOTE: this is recommended in some forums but DOES NOT WORK!
# APPDIR="$(dirname "$(dirname "$(readlink -fm "$0")")")"

# This is the right way: https://unix.stackexchange.com/a/216915
APPDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Export required variables.
export BASILISK="${APPDIR}/basilisk/src"
export PATH="${PATH}:${BASILISK}"

# Just check:
echo "BASILISK=${BASILISK}"
