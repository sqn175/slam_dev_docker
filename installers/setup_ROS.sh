#!/usr/bin/env bash

#setup ROS environment variables and source files
grep -q -F ' ROS_HOSTNAME' ~/.bashrc || echo 'export ROS_HOSTNAME=localhost' | tee -a ~/.bashrc
grep -q -F ' ROS_MASTER_URI' ~/.bashrc || echo 'export ROS_MASTER_URI=http://localhost:11311' | tee -a ~/.bashrc

echo "source /opt/ros/${ROS_DISTRO}/setup.bash" | tee -a ~/.bashrc
echo "source /slam_dev_src/devel/setup.bash" | tee -a ~/.bashrc
