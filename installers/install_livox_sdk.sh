#!/usr/bin/env bash

set -e

VERSION="2.3.0"
if [ $1 ]; then
    VERSION="$1"
fi

PKG_NAME="Livox-SDK"
echo -e "\033[32mInstalling ${PKG_NAME} ...\033[0m"

PKG_FILE="${PKG_NAME}-${VERSION}.tar.gz"
DOWNLOAD_LINK="https://github.com/Livox-SDK/Livox-SDK/archive/v${VERSION}.tar.gz"

pushd ${ARCHIVE_DIR}
if [[ -e "${ARCHIVE_DIR}/${PKG_FILE}" ]]; then
    echo "Using downloaded source files."
else
    wget "${DOWNLOAD_LINK}" -O "${PKG_FILE}"
fi
tar xzf ${PKG_FILE}

pushd "${PKG_NAME}-${VERSION}"
    rm -rf build & mkdir build && cd build
    cmake ../
    make -j$(nproc)
    make install
popd

# Clean up files
rm -rf ${PKG_FILE} ${PKG_NAME}-${VERSION}
popd

ldconfig

echo -e "Successfully installed ${PKG_NAME} ${VERSION}."
