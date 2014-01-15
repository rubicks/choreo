#!/usr/bin/env bash
#
# choreo/travis/install.sh

echo ${0}

# extant lein executable -> exit cleanly
[[ -x ${PROJECT_DIR}/bin/lein ]] && exit 0

# no source _noisy -> exit dirty
source ${PROJECT_DIR}/scripts/_noisy.sh || exit 1

url_lein=https://raw.github.com/technomancy/leiningen/stable/bin/lein

echo -n                                                && \
    _noisy mkdir -vp ${PROJECT_DIR}/bin                && \
    _noisy wget -O ${PROJECT_DIR}/bin/lein ${url_lein} && \
    _noisy chmod u+x ${PROJECT_DIR}/bin/lein
