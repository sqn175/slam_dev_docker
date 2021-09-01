#!/usr/bin/env bash

set -e

CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
. ${CURR_DIR}/installer_base.sh

PKG_NAME="opengv"
info "Installing ${PKG_NAME} ..."

VERSION="master"
PKG_FILE="${PKG_NAME}-${VERSION}.tar.gz"
CHECKSUM="acb7c12a99980a969b5ca8e3f232e6cc2eb753fc7faae7a1da4faa090b2cdfd0"
DOWNLOAD_LINK="https://github.com/laurentkneip/opengv/archive/${VERSION}.tar.gz"
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
