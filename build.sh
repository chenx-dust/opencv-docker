#!/bin/bash

SCRIPT_VERSION="v0.1"
DEFAULT_VERSION="4.5.4"
VERSION=$DEFAULT_VERSION
SOURCE_URL="https://github.com/opencv/opencv/archive/${VERSION}.zip"
CONTRIB_SOURCE_URL=" https://github.com/opencv/opencv_contrib/archive/${VERSION}.zip"
# RELEASE_JSON_URL="https://api.github.com/repos/opencv/opencv/releases/tags/${VERSION}"
BASE_CONTAINER="ubuntu:20.04"
CMAKE_ENV="env.cfg"
BUILD_THREAD=20
PWD=$(pwd)

STEP=0

################################
# TODO: * Add checksum.
#       * Add parameter. (Force re-download. Clean.)
#       * Add git version detect.
#       * Add apt mirror.
#       * Add proxy.
#       * Add cmake config.

DEPENDENCY_LIST="unzip wget docker"

function show_step() {
    STEP=`expr $STEP + 1`
    echo "STEP ${STEP}: $1"
}

function zip_clean() {
    rm "opencv-${VERSION}.zip"
    rm "opencv_contrib-${VERSION}.zip"
}

function env_clean() {
    rm -rf "opencv-${VERSION}"
    rm -rf "opencv_contrib-${VERSION}"
    rm -rf "build"
}

function check_dependency() {
    echo "Checking dependency..."
    for i in $DEPENDENCY_LIST; do
        if ! type $i 1> /dev/null 2> /dev/null; then
            echo "ERROR: Command \"$i\" not found." >&2
            echo "This script depends on:" >&2
            echo -e "\t${DEPENDENCY_LIST}" >&2
            exit -1
    fi;done
}

function download() {
    if [ ! -f $1 ]; then
        echo "\"$1\" not found. Now downloading from $2"
        wget $2 -O $1
        if [ $? == 0 ]; then
            echo "Downloaded successfully."
        else
            echo "ERROR: An error occurred while downloading $1" >&2
            exit -2
        fi
    else
        echo "\"$1\" found."
    fi
}

# Main Process
echo "OpenCV-Docker Build Script ${SCRIPT_VERSION}"
echo
check_dependency

show_step "Preparing source..."
download "opencv-${VERSION}.zip" ${SOURCE_URL}
download "opencv_contrib-${VERSION}.zip" ${CONTRIB_SOURCE_URL}
echo

show_step "Cleaning environment..."
env_clean

show_step "Unzipping source..."
unzip "opencv-${VERSION}.zip"
unzip "opencv_contrib-${VERSION}.zip"

show_step "Building with container..."
echo "Building..."
mkdir build
cp $CMAKE_ENV build/env.cfg
cp container.sh build/container.sh
chmod +x build/container.sh
docker run --rm -it \
    -v $PWD/build:/build -v "${PWD}/opencv-${VERSION}":/opencv -v "${PWD}/opencv_contrib-${VERSION}":/opencv_contrib \
    -e OD_BUILD_THREADS=$BUILD_THREADS \
    $BASE_CONTAINER /bin/bash -c /build/container.sh