#!/usr/bin/env bash

set -e

VERSION="2.6.0"
if [ $1 ]; then
    VERSION="$1"
fi

PKG_NAME="livox_ros_driver"
echo -e "\033[32mInstalling ${PKG_NAME} ...\033[0m"

if [ -z "${ROS_DISTRO}" ]; then
    echo "${PKG_NAME} installation failed. ROS not found."
    exit 1
fi

PKG_FILE="${PKG_NAME}-${VERSION}.tar.gz"
DOWNLOAD_LINK="https://github.com/Livox-SDK/livox_ros_driver/archive/v${VERSION}.tar.gz"

mkdir -p ${ARCHIVE_DIR}/tmp_ros_ws/src
pushd ${ARCHIVE_DIR}/tmp_ros_ws/src
    if [[ -e "${ARCHIVE_DIR}/${PKG_FILE}" ]]; then
        echo "Using downloaded source files."
    else
        wget "${DOWNLOAD_LINK}" -O "${PKG_FILE}"
    fi
    tar xzf ${PKG_FILE}
popd

. /opt/ros/${ROS_DISTRO}/setup.sh
catkin_make install

pushd src/
# Clean up files
rm -rf ${PKG_FILE} ${PKG_NAME}-${VERSION}
popd

ldconfig

echo -e "Successfully installed ${PKG_NAME} ${VERSION}."
