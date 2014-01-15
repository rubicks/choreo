#!/usr/bin/env bash

# choreo/scripts/_merge.sh

_dir=$(dirname ${BASH_SOURCE})
source ${_dir}/_do_or_die.sh || exit 1

function _merge()
{
    _branch_orig=$(git rev-parse --abbrev-ref HEAD)
    _do_or_die git checkout ${1}
    shift
    _do_or_die git merge --no-edit ${@}
    _do_or_die git push
    _do_or_die git checkout ${_branch_orig}
}

if [ "_merge.sh" == `basename ${0}` ]
then
    _merge ${@}
fi
