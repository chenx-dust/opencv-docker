ARG BUILD_THREAD=20
FROM ubuntu:20.04
RUN apt update \
    && DEBIAN_FRONTEND=noninteractive TZ=Asia/Shanghai apt install -y \ 
    cmake-qt-gui git vim build-essential pkg-config \
    python3-dev python3-numpy libtbb2 libtbb-dev libjpeg-dev \
    libpng-dev libtiff-dev libdc1394-22-dev \
    libeigen3-dev libgtk2.0-dev \
    libavcodec-dev libavformat-dev libswscale-dev \
    ccache libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgtk-3-dev libavresample-dev \
    libgphoto2-dev libopenblas-dev doxygen libhdf5-dev libgoogle-glog-dev libgflags-dev unzip wget
RUN wget https://github.com/opencv/opencv/archive/refs/tags/4.5.4.zip -O opencv-4.5.4.zip \
    && wget https://github.com/opencv/opencv_contrib/archive/refs/tags/4.5.4.zip -O opencv_contrib-4.5.4.zip \
    && unzip opencv-4.5.4.zip \
    && unzip opencv_contrib-4.5.4.zip
RUN cd opencv-4.5.4 \
    && mkdir build && cd build \
    && cmake -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib-4.5.4/modules -D WITH_EIGEN=ON -D WITH_TBB=ON -D ENABLE_FAST_MATH=ON -D OPENCV_GENERATE_PKGCONFIG=ON ..
RUN make -j${BUILD_THREAD} && make install