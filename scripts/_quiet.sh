#!/usr/bin/env bash

# choreo/scripts/_quiet.sh

function _quiet()
{
    echo && echo "$ <quiet command>" && eval ${@} 2>&1 > /dev/null
}

if [ "_quiet.sh" == `basename ${0}` ]
then
    _quiet ${@}
fi
