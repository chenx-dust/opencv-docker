#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export TZ=Asia/Shanghai

OD_CMAKE_ENV=$(cat /build/env.cfg)

apt update
apt install -y cmake-qt-gui git vim build-essential pkg-config \
    python3-dev python3-numpy libtbb2 libtbb-dev libjpeg-dev \
    libpng-dev libtiff-dev libdc1394-22-dev \
    libeigen3-dev libgtk2.0-dev \
    libavcodec-dev libavformat-dev libswscale-dev \
    ccache libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgtk-3-dev libavresample-dev \
    libgphoto2-dev libopenblas-dev doxygen libhdf5-dev libgoogle-glog-dev libgflags-dev
cd /build
cmake -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules $OD_CMAKE_ENV /opencv
make -j$OD_BUILD_THREADS