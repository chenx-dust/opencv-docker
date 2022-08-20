FROM ubuntu:20.04
ENV ARCHIVE_UBUNTU="mirrors.tuna.tsinghua.edu.cn"
ENV SECURITY_UBUNTU="mirrors.tuna.tsinghua.edu.cn"
RUN sed -i "s@archive.ubuntu.com@${ARCHIVE_UBUNTU}@g" /etc/apt/sources.list \
    && sed -i "s@security.ubuntu.com@${SECURITY_UBUNTU}@g" /etc/apt/sources.list \
    && apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y \ 
    cmake-qt-gui git vim build-essential pkg-config \
    python3-dev python3-numpy libtbb2 libtbb-dev libjpeg-dev \
    libpng-dev libtiff-dev libdc1394-22-dev \
    libeigen3-dev libgtk2.0-dev \
    libavcodec-dev libavformat-dev libswscale-dev \
    ccache libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgtk-3-dev libavresample-dev \
    libgphoto2-dev libopenblas-dev doxygen libhdf5-dev libgoogle-glog-dev libgflags-dev \
    linux-tools-virtual hwdata sudo \
    && update-alternatives --force --install /usr/bin/usbip usbip `ls /usr/lib/linux-tools/*/usbip | tail -n1` 20
