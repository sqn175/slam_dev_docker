#!/usr/bin/env bash

# This lib requires pre-installed Eigen3

set -e

VERSION="1.0.0"
if [ $1 ]; then
    VERSION="$1"
fi

PKG_NAME="Sophus"
echo -e "\033[32mInstalling ${PKG_NAME} ...\033[0m"

PKG_FILE="${PKG_NAME}-${VERSION}.tar.gz"
DOWNLOAD_LINK="https://github.com/strasdat/Sophus/archive/v${VERSION}.tar.gz"
if [[ -e "${ARCHIVE_DIR}/${PKG_FILE}" ]]; then
    echo "Using downloaded source files."
    mv -f "${ARCHIVE_DIR}/${PKG_FILE}" "${PKG_FILE}"
else
    wget "${DOWNLOAD_LINK}" -O "${PKG_FILE}"
fi
tar xzf ${PKG_FILE}

pushd "${PKG_NAME}-${VERSION}"
    mkdir build && cd build
    cmake ../
    make -j$(nproc)
    make install
popd

ldconfig

echo -e "Successfully installed ${PKG_NAME} ${VERSION}."

# Clean up files
rm -rf ${PKG_FILE} ${PKG_NAME}-${VERSION}

# Clean up cache to reduce layer size.
apt-get clean && \
    rm -rf /var/lib/apt/lists/*
