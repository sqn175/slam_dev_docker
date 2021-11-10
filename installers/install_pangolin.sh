#!/usr/bin/env bash

set -e

VERSION="0.6"
if [ $1 ]; then
    VERSION="$1"
fi

PKG_NAME="Pangolin"
echo -e "\033[32mInstalling ${PKG_NAME} ...\033[0m"

apt-get -y update && \
    apt-get -y install --no-install-recommends \
    libgl1-mesa-dev \
    libglew-dev \
    libwayland-dev \
    libxkbcommon-dev \
    wayland-protocols

PKG_FILE="${PKG_NAME}-${VERSION}.tar.gz"
DOWNLOAD_LINK="https://github.com/stevenlovegrove/Pangolin/archive/v${VERSION}.tar.gz"

pushd ${ARCHIVE_DIR}
if [[ -e "${ARCHIVE_DIR}/${PKG_FILE}" ]]; then
    echo "Using downloaded source files."
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

# Clean up files
rm -rf ${PKG_FILE} ${PKG_NAME}-${VERSION}
popd

ldconfig

echo -e "Successfully installed ${PKG_NAME} ${VERSION}."

# Clean up cache to reduce layer size.
apt-get clean && \
    rm -rf /var/lib/apt/lists/*
