#!/usr/bin/env bash

# choreo/mock-travis.sh
#
# mock the travis exports and do what travis does (as much as possible)
#
# http://about.travis-ci.org/docs/user/ci-environment/#Environment-variables
# 
# http://about.travis-ci.org/docs/user/build-configuration/#Build-Lifecycle


# travis-ci exports these envvars
export CI=${CI:-true}
export TRAVIS=${TRAVIS:-true}
# export DEBIAN_FRONTEND=${DEBIAN_FRONTEND:-noninteractive} (specific to Ubuntu)
export HAS_JOSH_K_SEAL_OF_APPROVAL=${HAS_JOSH_K_SEAL_OF_APPROVAL:-true}
# export USER=${USER:-travis (do not depend on this value)}
# export HOME=${HOME:-/home/travis (do not depend on this value)}
export LANG=${LANG:-en_US.UTF-8}
export LC_ALL=${LC_ALL:-en_US.UTF-8}
export RAILS_ENV=${RAILS_ENV:-test}
export RACK_ENV=${RACK_ENV:-test}
export MERB_ENV=${MERB_ENV:-test}
export JRUBY_OPTS=${JRUBY_OPTS:-"--server -Dcext.enabled=false -Xcompile.invokedynamic=false"}


export TRAVIS_BRANCH=$(git rev-parse --abbrev-ref HEAD)
export TRAVIS_BUILD_DIR=$(dirname $(readlink -nf ${BASH_SOURCE}))
export TRAVIS_BUILD_ID=""        # unmockable (for now)
export TRAVIS_BUILD_NUMBER=""    # unmockable (for now)
export TRAVIS_COMMIT=""          # unmockable (for now)
export TRAVIS_COMMIT_RANGE=""    # unmockable (for now)
export TRAVIS_JOB_ID=""          # unmockable (for now)
export TRAVIS_JOB_NUMBER=""      # unmockable (for now)
export TRAVIS_PULL_REQUEST=""    # unmockable (for now)
export TRAVIS_SECURE_ENV_VARS="" # unmockable (for now)
export TRAVIS_REPO_SLUG=""       # unmockable (for now)


export PROJECT_DIR=${TRAVIS_BUILD_DIR}
source ${PROJECT_DIR}/scripts/_noisy.sh || exit 1
source ${PROJECT_DIR}/scripts/_disp.sh  || exit 1


# travis defines some _system_* env vars
export _system_arch=$(uname -m)
export _system_type=$(uname -s)
case "${_system_type}" in
    Linux)
        export _system_name=$(lsb_release --id | awk '{print $NF}')
        export _system_version=$(lsb_release --release | awk '{print $NF}')
        ;;
    Darwin)
        export _system_name="OSX"
        export _system_version=$(sw_vers -productVersion)
        ;;
    *)
        disp _system_type
        exit 1
esac

# do what travis does
echo -n                                            && \
    _noisy ${PROJECT_DIR}/travis/before_install.sh && \
    _noisy ${PROJECT_DIR}/travis/install.sh        && \
    _noisy ${PROJECT_DIR}/travis/before_script.sh  && \
    _noisy ${PROJECT_DIR}/travis/script.sh

export TRAVIS_TEST_RESULT="${?}"

if [[ 0 == ${TRAVIS_TEST_RESULT} ]]
then
    _noisy ${PROJECT_DIR}/travis/after_failure.sh
else
    _noisy ${PROJECT_DIR}/travis/after_success.sh
fi

_noisy ${PROJECT_DIR}/travis/after_script.sh
