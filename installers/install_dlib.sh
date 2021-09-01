#!/usr/bin/env bash

set -e

CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
. ${CURR_DIR}/installer_base.sh

PKG_NAME="DLib"
info "Installing ${PKG_NAME} ..."

apt_get_update_and_install \
        cmake \
        libopencv-dev 

VERSION="1.1-free"
PKG_FILE="${PKG_NAME}-${VERSION}.tar.gz"
CHECKSUM="be5076b8bcced4c39c08ff00c9ccf478c757bb52be2ebb44513eccec1766f2a6"
DOWNLOAD_LINK="https://github.com/dorian3d/DLib/archive/v${VERSION}.tar.gz"
download_if_not_cached "${PKG_FILE}" "${CHECKSUM}" "${DOWNLOAD_LINK}"
tar xzf ${PKG_FILE}

pushd "${PKG_NAME}-${VERSION}"
    mkdir build && cd build
    cmake ../
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
