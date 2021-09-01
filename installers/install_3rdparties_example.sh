#!/usr/bin/env bash

set -e

CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
. ${CURR_DIR}/installer_base.sh

apt_get_update_and_install \
    libsuitesparse-dev \
    libomp-dev  \
    libeigen3-dev \
    ros-${ROS_DISTRO}-image-transport \
    ros-${ROS_DISTRO}-cv-bridge \
    ros-${ROS_DISTRO}-pcl-ros


bash ${CURR_DIR}/install_opencv.sh 
bash ${CURR_DIR}/install_pcl.sh
bash ${CURR_DIR}/install_qt.sh
bash ${CURR_DIR}/install_g2o.sh
bash ${CURR_DIR}/install_sophus.sh
bash ${CURR_DIR}/install_dlib.sh
bash ${CURR_DIR}/install_dbow2.sh

# Clean up cache to reduce layer size.
apt-get clean && \
    rm -rf /var/lib/apt/lists/*