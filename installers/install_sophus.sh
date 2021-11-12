#!/usr/bin/env bash

# Sophus currently requires pre-installed Eigen3.3.X
# Only master branch can successfully built on Linux

set -e

VERSION="master"
if [ $1 ]; then
    VERSION="$1"
fi

PKG_NAME="Sophus"
echo -e "\033[32mInstalling ${PKG_NAME} ...\033[0m"

PKG_FILE="${PKG_NAME}-${VERSION}.tar.gz"
DOWNLOAD_LINK="https://github.com/strasdat/Sophus/archive/v${VERSION}.tar.gz"
if [ $DOWNLOAD_LINK="master" ]; then
    DOWNLOAD_LINK="https://github.com/strasdat/Sophus/archive/master.tar.gz"
fi

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