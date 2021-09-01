#!/usr/bin/env bash

set -e

CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
. ${CURR_DIR}/installer_base.sh

PKG_NAME="Sophus"
info "Installing ${PKG_NAME} ..."

apt_get_update_and_install \
        cmake \
        libeigen3-dev

VERSION="1.0.0"
PKG_FILE="${PKG_NAME}-${VERSION}.tar.gz"
CHECKSUM="b4c8808344fe429ec026eca7eb921cef27fe9ff8326a48b72c53c4bf0804ad53"
DOWNLOAD_LINK="https://github.com/strasdat/Sophus/archive/v${VERSION}.tar.gz"
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
