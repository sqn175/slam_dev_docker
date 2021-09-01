#!/usr/bin/env bash

DOCKERFILE="Dockerfile.badslam"

set -e

docker build \
    --network=host \
    --tag slam_dev_${DOCKERFILE##*.}:latest \
    --file ${DOCKERFILE} .

echo "已构建新镜像"
