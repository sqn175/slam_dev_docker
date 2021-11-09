#!/usr/bin/env bash

set -e

# Default settings
HOST_SOURCE_DIR="slam/source/dir"
IMAGE_NAME="slam_dev"

XSOCK=/tmp/.X11-unix
XAUTH=$HOME/.Xauthority

VOLUMES="--volume=$XSOCK:$XSOCK:rw
         --volume=$HOST_SOURCE_DIR:/slam_dev_src:rw
         --volume=$HOME/.Xauthority:/root/.Xauthority"

xhost +local:root 1>/dev/null 2>&1

docker run \
    --privileged \
    -it --rm \
    --name slam_dev \
    --user slam_dev \
    $VOLUMES \
    --env DISPLAY=${DISPLAY} \
    --env XAUTHORITY=${XAUTH} \
    --net host \
    --workdir /slam_dev_src \
    --add-host raw.githubusercontent.com:151.101.84.133 \
    "${IMAGE_NAME}:latest"

xhost -local:root 1>/dev/null 2>&1
