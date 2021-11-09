#!/usr/bin/env bash
set -e

DOCKERFILE="Dockerfile.ubuntu18-opengl"
IMAGE_NAME="slam_dev"

docker build \
    --network=host \
    --tag ${IMAGE_NAME}:latest \
    --file ${DOCKERFILE} .

echo "Docker container built!"
