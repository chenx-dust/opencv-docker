FROM ubuntu:20.04
ARG ARCHIVE_UBUNTU="mirrors.tuna.tsinghua.edu.cn"
ARG SECURITY_UBUNTU="mirrors.tuna.tsinghua.edu.cn"
ARG TIME_ZONE=Asia/Shanghai
RUN sed -i "s@archive.ubuntu.com@${ARCHIVE_UBUNTU}@g" /etc/apt/sources.list \
    && sed -i "s@security.ubuntu.com@${SECURITY_UBUNTU}@g" /etc/apt/sources.list \
    && apt update \
    && DEBIAN_FRONTEND=noninteractive TZ=$TIME_ZONE apt install -y \ 
    cmake-qt-gui git vim build-essential pkg-config \
    python3-dev python3-numpy libtbb2 libtbb-dev libjpeg-dev \
    libpng-dev libtiff-dev libdc1394-22-dev \
    libeigen3-dev libgtk2.0-dev \
    libavcodec-dev libavformat-dev libswscale-dev \
    ccache libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgtk-3-dev libavresample-dev \
    libgphoto2-dev libopenblas-dev doxygen libhdf5-dev libgoogle-glog-dev libgflags-dev
ENTRYPOINT /bin/bash
