#!/usr/bin/env bash

set -e

# Default settings
HOST_SOURCE_DIR="/home/qin/Documents/sources/demos/visual_lidar_slam_collection"
IMAGE="slam_dev_badslam:latest"

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
    $IMAGE

xhost -local:root 1>/dev/null 2>&1
