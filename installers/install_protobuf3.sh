#!/usr/bin/env bash

set -e

CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
. ${CURR_DIR}/installer_base.sh

PKG_NAME="protobuf"
info "Installing ${PKG_NAME} ..."

apt_get_update_and_install \
        cmake \
        ninja-build

VERSION="3.14.0"
PKG_FILE="${PKG_NAME}-${VERSION}.tar.gz"
CHECKSUM="d0f5f605d0d656007ce6c8b5a82df3037e1d8fe8b121ed42e536f569dec16113"
DOWNLOAD_LINK="https://github.com/protocolbuffers/protobuf/archive/v${VERSION}.tar.gz"
download_if_not_cached "${PKG_FILE}" "${CHECKSUM}" "${DOWNLOAD_LINK}"
tar xzf ${PKG_FILE}

pushd "${PKG_NAME}-${VERSION}"
    mkdir build && cd build
    cmake -G Ninja \
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
      -DCMAKE_BUILD_TYPE=Release \
      -Dprotobuf_BUILD_TESTS=OFF \
      ../cmake
    ninja
    sudo ninja install
popd

ldconfig

ok "Successfully installed ${PKG_NAME} ${VERSION}."

# Clean up files
rm -rf ${PKG_FILE} ${PKG_NAME}-${VERSION}

# Clean up cache to reduce layer size.
apt-get clean && \
    rm -rf /var/lib/apt/lists/*
