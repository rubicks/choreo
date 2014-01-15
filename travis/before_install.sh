#!/usr/bin/env bash
#
# choreo/travis/before_install.sh

echo ${0}

source ${PROJECT_DIR}/scripts/_disp.sh || exit 1

_disp _system_arch
_disp _system_name
_disp _system_type
_disp _system_version
