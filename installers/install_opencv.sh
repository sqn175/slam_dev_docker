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

set -e

CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
. ${CURR_DIR}/installer_base.sh

# 1) Install OpenCV via apt
apt_get_update_and_install \
   libopencv-core-dev \
   libopencv-imgproc-dev \
   libopencv-imgcodecs-dev \
   libopencv-highgui-dev \
   libopencv-dev
exit 0
# 2) Build OpenCV from source
# RTFM: https://src.fedoraproject.org/rpms/opencv/blob/master/f/opencv.spec

if ldconfig -p | grep -q libopencv_core ; then
    info "OpenCV was already installed"
    exit 0
fi

WORKHORSE="$1"
if [ -z "${WORKHORSE}" ]; then
    WORKHORSE="cpu"
fi

BUILD_CONTRIB="no"

apt_get_update_and_install \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libv4l-dev \
        libeigen3-dev \
        libopenblas-dev \
        libatlas-base-dev \
        libxvidcore-dev \
        libx264-dev \
        libopenni-dev \
        libwebp-dev

pip3_install numpy

VERSION="3.4.5"

PKG_OCV="opencv-${VERSION}.tar.gz"
CHECKSUM="0c57d9dd6d30cbffe68a09b03f4bebe773ee44dc8ff5cd6eaeb7f4d5ef3b428e"
DOWNLOAD_LINK="https://github.com/opencv/opencv/archive/${VERSION}.tar.gz"
download_if_not_cached "${PKG_OCV}" "${CHECKSUM}" "${DOWNLOAD_LINK}"
tar xzf ${PKG_OCV}

if [ "${BUILD_CONTRIB}" = "yes" ]; then
    PKG_CONTRIB="opencv_contrib-${VERSION}.tar.gz"
    CHECKSUM="a69772f553b32427e09ffbfd0c8d5e5e47f7dab8b3ffc02851ffd7f912b76840"
    DOWNLOAD_LINK="https://github.com/opencv/opencv_contrib/archive/${VERSION}.tar.gz"
    download_if_not_cached "${PKG_CONTRIB}" "${CHECKSUM}" "${DOWNLOAD_LINK}"
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

if [ "${BUILD_CONTRIB}" = "yes" ]; then
    EXTRA_OPTIONS="${EXTRA_OPTIONS} -DOPENCV_EXTRA_MODULES_PATH=\"../../opencv_contrib-${VERSION}/modules\""
fi

# -DBUILD_LIST=core,highgui,improc
pushd "opencv-${VERSION}"
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
            -DWITH_GTK=OFF  \
            -DWITH_IPP=OFF  \
            -DWITH_ITT=OFF  \
            -DWITH_TBB=OFF  \
            -DWITH_EIGEN=ON \
            -DWITH_FFMPEG=ON   \
            -DWITH_LIBV4L=ON   \
            -DWITH_OPENMP=ON   \
            -DWITH_OPENNI=ON   \
            -DWITH_OPENCL=ON   \
            -DWITH_WEBP=ON     \
            -DOpenGL_GL_PREFERENCE=GLVND \
            -DBUILD_opencv_python2=OFF  \
            -DBUILD_opencv_python3=ON   \
            -DBUILD_NEW_PYTHON_SUPPORT=ON \
            -DPYTHON_DEFAULT_EXECUTABLE="$(which python3)" \
            -DOPENCV_PYTHON3_INSTALL_PATH="/usr/local/lib/python$(py3_version)/dist-packages" \
            -DOPENCV_ENABLE_NONFREE=ON \
            -DCV_TRACE=OFF      \
            ${GPU_OPTIONS}    	\
            ${EXTRA_OPTIONS}

        make -j$(nproc)
        make install
popd

ldconfig

ok "Successfully installed OpenCV ${VERSION}."

rm -rf "${PKG_OCV}" "opencv-${VERSION}"

if [ "${BUILD_CONTRIB}" = "yes" ]; then
    rm -rf "${PKG_CONTRIB}" "opencv_contrib-${VERSION}"
fi
