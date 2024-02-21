#!/usr/bin/env bash

###############################################################################
# Copyright 2020 The Apollo Authors. All Rights Reserved.
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
# Fail on first error.

# This lib requires pre-installed Eigen3

set -e

PKG_NAME="opencv"
echo -e "\033[32mInstalling ${PKG_NAME} ...\033[0m"

INSTALL_CONTRIB="no"

VERSION="3.4.1"
if [ $1 ]; then
    VERSION="$1"
else
    if ldconfig -p | grep -q libopencv_core ; then
        echo "OpenCV was already installed. Skip."
        exit 0
    fi

    # Install OpenCV via apt
    apt-get -y update && \
            apt-get -y install --no-install-recommends \
        libopencv-core-dev \
        libopencv-imgproc-dev \
        libopencv-imgcodecs-dev \
        libopencv-highgui-dev \
        libopencv-dev

    if [ "${INSTALL_CONTRIB}" = "yes" ]; then
        apt-get -y update && \
            apt-get -y install --no-install-recommends \
            libopencv-contrib-dev
    fi
    exit 0
fi

WORKHORSE="$2"
if [ -z "${WORKHORSE}" ]; then
    WORKHORSE="cpu"
fi

# Build OpenCV from source
# RTFM: https://src.fedoraproject.org/rpms/opencv/blob/master/f/opencv.spec

apt-get -y update && \
    apt-get -y install --no-install-recommends \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libv4l-dev \
    libopenblas-dev \
    liblapacke-dev \
    libatlas-base-dev \
    libxvidcore-dev \
    libx264-dev \
    libopenni-dev \
    libwebp-dev \
    libgtk2.0-dev \
    libvtk7-dev

python3 -m pip install --default-timeout=100 --no-cache-dir numpy

PKG_FILE="${PKG_NAME}-${VERSION}.tar.gz"
DOWNLOAD_LINK="https://github.com/opencv/opencv/archive/${VERSION}.tar.gz"

pushd ${ARCHIVE_DIR}
if [[ -e "${ARCHIVE_DIR}/${PKG_FILE}" ]]; then
    echo "Using downloaded source files."
else
    wget "${DOWNLOAD_LINK}" -O "${PKG_FILE}"
fi
tar xzf ${PKG_FILE}

if [ "${INSTALL_CONTRIB}" = "yes" ]; then
    PKG_CONTRIB="opencv_contrib-${VERSION}.tar.gz"
    CHECKSUM="a69772f553b32427e09ffbfd0c8d5e5e47f7dab8b3ffc02851ffd7f912b76840"
    DOWNLOAD_LINK="https://github.com/opencv/opencv_contrib/archive/${VERSION}.tar.gz"
    if [[ -e "${ARCHIVE_DIR}/${PKG_CONTRIB}" ]]; then
        echo "Using downloaded source files."
    else
        wget "${DOWNLOAD_LINK}" -O "${PKG_CONTRIB}"
    fi
    tar xzf ${PKG_CONTRIB}
fi

# libgtk-3-dev libtbb2 libtbb-dev
# -DWITH_GTK=ON -DWITH_TBB=ON

GPU_OPTIONS=
if [ "${WORKHORSE}" = "gpu" ]; then
    GPU_OPTIONS="-DWITH_CUDA=ON -DWITH_CUFFT=ON -DWITH_CUBLAS=ON -DWITH_CUDNN=ON"
    GPU_OPTIONS="${GPU_OPTIONS} -DCUDA_PROPAGATE_HOST_FLAGS=OFF"
    GPU_OPTIONS="${GPU_OPTIONS} -DCUDA_ARCH_BIN=\"${SUPPORTED_NVIDIA_SMS}\""
    # GPU_OPTIONS="${GPU_OPTIONS} -DWITH_NVCUVID=ON"
else
    GPU_OPTIONS="-DWITH_CUDA=OFF"
fi

TARGET_ARCH="$(uname -m)"

EXTRA_OPTIONS=
if [ "${TARGET_ARCH}" = "x86_64" ]; then
    EXTRA_OPTIONS="${EXTRA_OPTIONS} -DCPU_BASELINE=SSE4"
fi

if [ "${INSTALL_CONTRIB}" = "yes" ]; then
    EXTRA_OPTIONS="${EXTRA_OPTIONS} -DOPENCV_EXTRA_MODULES_PATH=$(pwd)/opencv_contrib-${VERSION}/modules"
fi

# -DBUILD_LIST=core,highgui,improc
pushd "${PKG_NAME}-${VERSION}"
    mkdir build && cd build
        cmake .. \
            -DCMAKE_BUILD_TYPE=Release \
            -DBUILD_SHARED_LIBS=ON          \
            -DENABLE_PRECOMPILED_HEADERS=OFF \
            -DOPENCV_GENERATE_PKGCONFIG=ON  \
            -DBUILD_EXAMPLES=OFF \
            -DBUILD_DOCS=OFF    \
            -DBUILD_TESTS=OFF   \
            -DBUILD_PERF_TESTS=OFF  \
            -DBUILD_JAVA=OFF     \
            -DBUILD_PROTOBUF=OFF \
            -DPROTOBUF_UPDATE_FILES=ON \
            -DINSTALL_C_EXAMPLES=OFF   \
            -DBUILD_opencv_python2=OFF  \
            -DBUILD_opencv_python3=ON   \
            -DBUILD_NEW_PYTHON_SUPPORT=ON \
            -DPYTHON_DEFAULT_EXECUTABLE="$(which python3)" \
            -DOPENCV_PYTHON3_INSTALL_PATH="/usr/local/lib/python$(py3versions -v -i)/dist-packages" \
            -DOPENCV_ENABLE_NONFREE=ON \
            -DCV_TRACE=OFF      \
            ${GPU_OPTIONS}    	\
            ${EXTRA_OPTIONS}    \
            -DBUILD_opencv_xfeatures2d=OFF

        make -j$(nproc)
        make install
popd

rm -rf "${PKG_FILE}" "${PKG_NAME}-${VERSION}"

if [ "${INSTALL_CONTRIB}" = "yes" ]; then
    rm -rf "${PKG_CONTRIB}" "opencv_contrib-${VERSION}"
fi
popd

ldconfig

echo -e "Successfully installed OpenCV ${VERSION}."

# Clean up cache to reduce layer size.
apt-get clean && \
    rm -rf /var/lib/apt/lists/*