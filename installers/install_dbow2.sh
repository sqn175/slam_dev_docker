#!/usr/bin/env bash

set -e

CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
. ${CURR_DIR}/installer_base.sh

PKG_NAME="DBoW2"
info "Installing ${PKG_NAME} ..."

apt_get_update_and_install \
        cmake \
        libopencv-dev 

VERSION="1.1-free"
PKG_FILE="${PKG_NAME}-${VERSION}.tar.gz"
CHECKSUM="b5d68c4097a45ec2fabe10d7d0dc731c2ecd931ac3886d8f2ade2e942670143c"
DOWNLOAD_LINK="https://github.com/dorian3d/DBoW2/archive/v${VERSION}.tar.gz"
download_if_not_cached "${PKG_FILE}" "${CHECKSUM}" "${DOWNLOAD_LINK}"
tar xzf ${PKG_FILE}

pushd "${PKG_NAME}-${VERSION}"
    mkdir build && cd build
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        ..
    make -j$(nproc)
    make install
popd

ldconfig

ok "Successfully installed ${PKG_NAME} ${VERSION}."

# Clean up files
rm -rf ${PKG_FILE} ${PKG_NAME}-${VERSION}

# Clean up cache to reduce layer size.
apt-get clean && \
    rm -rf /var/lib/apt/lists/*
