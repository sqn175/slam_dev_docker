#!/usr/bin/env bash

set -e

CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
. ${CURR_DIR}/installer_base.sh

PKG_NAME="g2o"
info "Installing ${PKG_NAME} ..."

apt_get_update_and_install \
    cmake \
    libeigen3-dev

VERSION="20200410_git"
PKG_FILE="${PKG_NAME}-${VERSION}.tar.gz"
CHECKSUM="b79eb1407ae7f2a9e6a002bb4b41d65402c185855db41a9ef4a6e3b42abaec4c"
DOWNLOAD_LINK="https://github.com/RainerKuemmerle/g2o/archive/${VERSION}.tar.gz"
download_if_not_cached "${PKG_FILE}" "${CHECKSUM}" "${DOWNLOAD_LINK}"
tar xzf ${PKG_FILE}

pushd "${PKG_NAME}-${VERSION}"
mkdir build && cd build
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DCMAKE_CXX_FLAGS=-std=c++11 \
    -DBUILD_SHARED_LIBS=ON \
    -DBUILD_UNITTESTS=OFF \
    -DBUILD_WITH_MARCH_NATIVE=ON \
    -DG2O_USE_CHOLMOD=OFF \
    -DG2O_USE_CSPARSE=ON \
    -DG2O_USE_OPENGL=OFF \
    -DG2O_USE_OPENMP=OFF \
    ..
make -j$(nproc)
make install
popd

ldconfig

ok "Successfully installed ${PKG_NAME} ${VERSION}."

# Clean up files
rm -rf ${PKG_FILE} ${PKG_NAME}-${VERSION}

# Clean up cache to reduce layer size.
apt-get clean &&
    rm -rf /var/lib/apt/lists/*
