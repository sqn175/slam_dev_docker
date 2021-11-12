#!/usr/bin/env bash

set -e

export ARCHIVE_DIR="/tmp/archive"
CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# 1) Install some dependencies via apt
# apt-get -y update && \
#     apt-get -y install --no-install-recommends \
#     

# 2) Install dependencies via buiding from source
# Eigen3 and OpenCV should be installed first as they may be 
# the dependencies of other libs
bash ${CURR_DIR}/install_eigen3.sh      3.3.4
bash ${CURR_DIR}/install_opencv.sh      3.3.0
bash ${CURR_DIR}/install_pangolin.sh

# Clean up cache to reduce layer size.
apt-get clean && \
    rm -rf /var/lib/apt/lists/*

