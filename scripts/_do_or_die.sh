#!/usr/bin/env bash

# choreo/scripts/_do_or_die.sh

_dir=$(dirname ${BASH_SOURCE})
source ${_dir}/_noisy.sh || exit 1

function _do_or_die()
{
    _noisy ${@}
    ret=${?}
    if [[ "0" -ne "${ret}" ]]
    then
        echo "failure: \"${@}\" returned ${ret}"
        exit ${ret}
    fi
}

if [ "_do_or_die.sh" == `basename ${0}` ]
then
    _do_or_die ${@}
fi
