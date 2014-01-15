#!/usr/bin/env bash

# choreo/scripts/_noisy.sh

function _noisy()
{
    echo && echo "$" ${@} && eval ${@}
}

if [ "_noisy.sh" == `basename ${0}` ]
then
    _noisy ${@}
fi
