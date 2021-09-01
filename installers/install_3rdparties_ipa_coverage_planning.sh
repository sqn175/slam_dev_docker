#!/usr/bin/env bash

set -e

CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
. ${CURR_DIR}/installer_base.sh

echo "Installing 3rdparty debs ..."

apt_get_update_and_install \
    libboost-all-dev   \
    libeigen3-dev \
    libglew-dev   \
    libgtest-dev  \
    libsuitesparse-dev \
    coinor-libcoinutils-dev \
    coinor-libclp-dev \
    coinor-libcbc-dev \
    coinor-libcgl-dev \
    libqsopt-ex2

# Install ROS packages
apt_get_update_and_install \
    ros-${ROS_DISTRO}-cob-extern \
    ros-${ROS_DISTRO}-urdf \
    ros-${ROS_DISTRO}-diagnostic-updater \
    ros-${ROS_DISTRO}-tf \
    ros-${ROS_DISTRO}-cv-bridge \
    ros-${ROS_DISTRO}-image-transport \
    ros-${ROS_DISTRO}-tf2-geometry-msgs \
    ros-${ROS_DISTRO}-angles \
    ros-${ROS_DISTRO}-navigation \
    ros-${ROS_DISTRO}-eigen-conversions \
    ros-${ROS_DISTRO}-pcl-ros \
    ros-${ROS_DISTRO}-image-geometry \
    ros-${ROS_DISTRO}-interactive-markers \
    ros-${ROS_DISTRO}-rviz \
    ros-${ROS_DISTRO}-rqt-reconfigure

echo "Installing 3rdparty debs ..."

bash ${CURR_DIR}/install_opencv.sh

# Call 'sudo rosdep init' and 'rosdep update' may cause following error:
# - ERROR: cannot download default sources list from:
# - https://raw.githubusercontent.com/ros/rosdistro/master/rosdep/sources.list.d/20-default.list 
# - Website may be down.
# Manually download the 20-default.list instead of 'sudo rosdep init' 
mv /tmp/archive/20-default.list /etc/ros/rosdep/sources.list.d/20-default.list

# Clean up cache to reduce layer size.
apt-get clean && \
    rm -rf /var/lib/apt/lists/*
