#!/usr/bin/env bash
###############################################################################
# Copyright 2018 The Apollo Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################

set -e

PKG_NAME="pcl-pcl"
echo -e "\033[32mInstalling ${PKG_NAME} ...\033[0m"

VERSION="1.10.1"
if [ $1 ]; then
    VERSION="$1"
else 
    # Install PCL via apt
    apt-get -y update && \
        apt-get -y install --no-install-recommends \
        libpcl-dev
    exit 0
fi

WORKHORSE="$2"
if [ -z "${WORKHORSE}" ]; then
    WORKHORSE="cpu"
fi

# Build PCL from source
GPU_OPTIONS="-DCUDA_ARCH_BIN=\"${SUPPORTED_NVIDIA_SMS}\""
if [ "${WORKHORSE}" = "cpu" ]; then
    GPU_OPTIONS="-DWITH_CUDA=OFF"
fi

echo "GPU Options for PCL:\"${GPU_OPTIONS}\""

apt-get -y update && \
    apt-get -y install --no-install-recommends \
    libboost-all-dev \
    libflann-dev \
    libglew-dev \
    libglfw3-dev \
    freeglut3-dev \
    libusb-1.0-0-dev \
    libopenni-dev \
    libjpeg-dev \
    libpng-dev \
    libpcap-dev \
    libopenmpi-dev \
    libvtk7-dev

# NOTE(storypku)
# libglfw3-dev depends on libglfw3,
# and libglew-dev have a dependency over libglew2.0

PKG_FILE="${PKG_NAME}-${VERSION}.tar.gz"
DOWNLOAD_LINK="https://github.com/PointCloudLibrary/pcl/archive/pcl-${VERSION}.tar.gz"

pushd ${ARCHIVE_DIR}
if [[ -e "${ARCHIVE_DIR}/${PKG_FILE}" ]]; then
    echo "Using downloaded source files."
else
    wget "${DOWNLOAD_LINK}" -O "${PKG_FILE}"
fi
tar xzf ${PKG_FILE}

# Ref: https://src.fedoraproject.org/rpms/pcl.git
#  -DPCL_PKGCONFIG_SUFFIX:STRING="" \
#  -DCMAKE_SKIP_RPATH=ON \

pushd "${PKG_NAME}-${VERSION}"
    mkdir build && cd build
    cmake .. \
        "${GPU_OPTIONS}" \
        -DWITH_DOCS=OFF \
        -DWITH_TUTORIALS=OFF \
        -DBUILD_documentation=OFF \
        -DBUILD_global_tests=OFF \
        -DBUILD_SHARED_LIBS=ON \
        -DBUILD_GPU=ON \
        -DBUILD_apps=ON \
        -DCMAKE_BUILD_TYPE=Release

    make -j$(nproc)
    make install
popd

#clean up
rm -rf ${PKG_NAME} ${PKG_NAME}-${VERSION}
popd

ldconfig

echo -e "Successfully installed ${PKG_NAME} ${VERSION}."

# Clean up cache to reduce layer size.
apt-get clean && \
    rm -rf /var/lib/apt/lists/*
