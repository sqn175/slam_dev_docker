#!/usr/bin/env bash

# This lib requires pre-installed OpenCV

set -e

VERSION="1.1-free"
if [ $1 ]; then
    VERSION="$1"
fi

PKG_NAME="DBoW2"
echo -e "\033[32mInstalling ${PKG_NAME} ...\033[0m"

PKG_FILE="${PKG_NAME}-${VERSION}.tar.gz"
DOWNLOAD_LINK="https://github.com/dorian3d/DBoW2/archive/v${VERSION}.tar.gz"
if [[ -e "${ARCHIVE_DIR}/${PKG_FILE}" ]]; then
    echo "Using downloaded source files."
    mv -f "${ARCHIVE_DIR}/${PKG_FILE}" "${PKG_FILE}"
else
    wget "${DOWNLOAD_LINK}" -O "${PKG_FILE}"
fi
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

echo -e "Successfully installed ${PKG_NAME} ${VERSION}."

# Clean up files
rm -rf ${PKG_FILE} ${PKG_NAME}-${VERSION}

# Clean up cache to reduce layer size.
apt-get clean && \
    rm -rf /var/lib/apt/lists/*
