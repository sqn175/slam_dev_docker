#!/usr/bin/env bash
set -e

DOCKERFILE="Dockerfile.slam-dev-ubuntu18-opengl"
if [ $1 ]; then
    DOCKERFILE="$1"
fi
IMAGE_NAME="${DOCKERFILE##*.}"

docker build \
    --network=host \
    --tag ${IMAGE_NAME}:latest \
    --file ${DOCKERFILE} .

echo "Docker container built!"
