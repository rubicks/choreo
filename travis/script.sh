#!/usr/bin/env bash
#
# choreo/travis/script.sh

echo ${0}

source ${PROJECT_DIR}/scripts/_noisy.sh || exit 1

echo -n                                  && \
    _noisy ${PROJECT_DIR}/bin/lein clean && \
    _noisy ${PROJECT_DIR}/bin/lein test  && \
    _noisy ${PROJECT_DIR}/bin/lein uberjar
