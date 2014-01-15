#!/usr/bin/env bash

# choreo/scripts/_install_if_missing.sh

_dir=$(dirname ${BASH_SOURCE})
source ${_dir}/_disp.sh      || exit 1
source ${_dir}/_noisy.sh     || exit 1
source ${_dir}/_do_or_die.sh || exit 1

case "${_system_name}" in
    Ubuntu)
        query_cmd="dpkg-query --status"
        install_cmd="sudo apt-get --assume-yes install"
        ;;
    OSX)
        query_cmd="brew list"
        install_cmd="brew install"
        ;;
    *)
        disp _system_name
        exit 1
esac

function _install_if_missing()
{
    for arg in ${@}
    do
        _noisy ${query_cmd} ${arg} || \
            _do_or_die ${install_cmd} ${arg}
    done
}

if [ "_install_if_missing.sh" == `basename ${0}` ]
then
    _install_if_missing ${@}
fi
