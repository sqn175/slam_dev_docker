#!/usr/bin/env bash

set -e

VERSION="20211102.0"
if [ $1 ]; then
    VERSION="$1"
fi

PKG_NAME="abseil"
echo -e "\033[32mInstalling ${PKG_NAME} ...\033[0m"

apt-get -y update && \
    apt-get -y install --no-install-recommends \
    stow

PKG_FILE="${PKG_NAME}-${VERSION}.tar.gz"
DOWNLOAD_LINK="https://github.com/abseil/abseil-cpp/archive/refs/tags/${VERSION}.tar.gz"

pushd ${ARCHIVE_DIR}
if [[ -e "${ARCHIVE_DIR}/${PKG_FILE}" ]]; then
    echo "Using downloaded source files."
else
    wget "${DOWNLOAD_LINK}" -O "${PKG_FILE}"
fi
tar xzf ${PKG_FILE}

pushd "${PKG_NAME}-cpp-${VERSION}"
    mkdir build && cd build
    cmake -G Ninja \
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local/stow/absl \
      ..

    ninja
    sudo ninja install
    cd /usr/local/stow
    stow absl
popd

# Clean up files
rm -rf ${PKG_FILE} ${PKG_NAME}-${VERSION}
popd

ldconfig

echo -e "Successfully installed ${PKG_NAME} ${VERSION}."
