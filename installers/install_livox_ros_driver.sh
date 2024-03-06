#!/usr/bin/env bash

set -e

VERSION="2.6.0"
if [ $1 ]; then
    VERSION="$1"
fi

PKG_NAME="livox_ros_driver"
echo -e "\033[32mInstalling ${PKG_NAME} ...\033[0m"
# Only return the first User_name.
USER_NAME=$(awk -F':' '/\/home/ {print $1; exit}' /etc/passwd)

if [ -z "${ROS_DISTRO}" ]; then
    echo "${PKG_NAME} installation failed. ROS not found."
    exit 1
fi

apt-get -y update && \
        apt-get -y install --no-install-recommends \
    ros-${ROS_DISTRO}-pcl-ros \
    ros-${ROS_DISTRO}-pcl-ros* \
    ros-${ROS_DISTRO}-pcl-conversions

PKG_FILE="${PKG_NAME}-${VERSION}.tar.gz"
DOWNLOAD_LINK="https://github.com/Livox-SDK/livox_ros_driver/archive/v${VERSION}.tar.gz"

mkdir -p /home/$USER_NAME/livox_ros_ws/src
pushd ${ARCHIVE_DIR}
    if [[ -e "${ARCHIVE_DIR}/${PKG_FILE}" ]]; then
        echo "Using downloaded source files."
    else
        wget "${DOWNLOAD_LINK}" -O "${PKG_FILE}"
    fi
    tar xzf ${PKG_FILE} -C /home/$USER_NAME/livox_ros_ws/src
    rm ${PKG_FILE}
popd

pushd /home/$USER_NAME/livox_ros_ws/
    . /opt/ros/${ROS_DISTRO}/setup.sh
    catkin_make
    echo "source /home/$USER_NAME/livox_ros_ws/devel/setup.bash" >> /home/$USER_NAME/.bashrc
popd

ldconfig

echo -e "Successfully installed ${PKG_NAME} ${VERSION}."
