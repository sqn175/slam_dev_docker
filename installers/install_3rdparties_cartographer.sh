#!/usr/bin/env bash

set -e

export ARCHIVE_DIR="/tmp/archive"
CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# 1) Install some dependencies via apt
apt-get -y update && \
    apt-get -y install --no-install-recommends \
    clang \
    cmake \
    g++ \
    git \
    google-mock \
    libboost-all-dev \
    libcairo2-dev \
    libceres-dev \
    libcurl4-openssl-dev \
    libeigen3-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    liblua5.2-dev \
    libsuitesparse-dev \
    lsb-release \
    ninja-build \
    python3-sphinx \
    stow

# 2) Install dependencies via buiding from source
# Eigen3 and OpenCV should be installed first as they may be 
# the dependencies of other libs
bash ${CURR_DIR}/install_abseil.sh
bash ${CURR_DIR}/install_protobuf3.sh 3.4.1

# Clean up cache to reduce layer size.
apt-get clean && \
    rm -rf /var/lib/apt/lists/*

