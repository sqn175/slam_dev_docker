#!/usr/bin/env bash

set -e

CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
. ${CURR_DIR}/installer_base.sh

apt_get_update_and_install \
    libboost-all-dev   \
    libeigen3-dev \
    libglew-dev   \
    libgtest-dev  \
    libsuitesparse-dev \
    zlib1g \
    libqt5opengl5-dev \
    libqt5x11extras5-dev
    
bash ${CURR_DIR}/install_dlib.sh
bash ${CURR_DIR}/install_g2o.sh
bash ${CURR_DIR}/install_opencv.sh
bash ${CURR_DIR}/install_opengv.sh
bash ${CURR_DIR}/install_qt.sh

# Clean up cache to reduce layer size.
apt-get clean && \
    rm -rf /var/lib/apt/lists/*