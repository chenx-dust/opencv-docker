#!/bin/bash

if ! source $1 1> /dev/null 2> /dev/null; then
    echo "ERROR: Wrong config." >&2
    echo "Usage: clean.sh CONFIG_PATH"
    exit -3
fi

PWD="$(pwd)"
STEP=0

################################
# TODO: * Add checksum.
#       * Add parameter. (Force re-download. Clean.)
#       * Add git version detect.
#       * Add apt mirror.
#       * Add proxy.
#       * Add cuda support.
#       * Exit when failing to exec in container

DEPENDENCY_LIST="unzip wget docker"

function show_step() {
    STEP=`expr $STEP + 1`
    echo "STEP ${STEP}: $1"
}

function exec_check() {
    RTN=$?
    if [ $RTN != 0 ]; then
        echo "Excute failed with code: ${RTN}" >&2
        exit $RTN
    fi
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

function rm_ifsudo() {
    if ! rm -rf "$1"; then
        echo "Failed to clean without sudo."
        sudo rm -rf "$1"
    fi
}

# Main Process
echo "OpenCV-Docker Build Script ${SCRIPT_VERSION}"
echo
show_step "Checking dependency..."
for i in $DEPENDENCY_LIST; do
    if ! type $i 1> /dev/null 2> /dev/null; then
        echo "ERROR: Command \"$i\" not found." >&2
        echo "This script depends on:" >&2
        echo -e "\t${DEPENDENCY_LIST}" >&2
        exit -1
fi;done

show_step "Preparing source..."
download "opencv-${VERSION}.zip" "${SOURCE_URL}"
download "opencv_contrib-${VERSION}.zip" "${CONTRIB_SOURCE_URL}"
echo

if [ $CLEAN_BUILD == 1 ]; then
    show_step "Cleaning environment..."
    rm_ifsudo "opencv-${VERSION}"
    rm_ifsudo "opencv_contrib-${VERSION}"
    rm_ifsudo "build"
    rm $OUTPUT
fi

show_step "Unzipping source..."
unzip "opencv-${VERSION}.zip" > /dev/null || exec_check
unzip "opencv_contrib-${VERSION}.zip" > /dev/null || exec_check

show_step "Building basic image..."
docker build -t opencv-docker:build -f "${BUILD_DOCKERFILE}" . || exec_check

show_step "Building OpenCV..."
mkdir build
cp ${CONTAINER_SCRIPT} build/build.sh
docker run -it --name build-env \
    -v $PWD/build:/build -v "${PWD}/opencv-${VERSION}":/opencv -v "${PWD}/opencv_contrib-${VERSION}":/opencv_contrib \
    -e OD_BUILD_THREADS=$BUILD_THREADS -e OD_CMAKE_ENV="${CMAKE_ENV}" \
    opencv-docker:build /bin/bash -c /build/build.sh || exec_check
docker container rm build-env
docker commit build-env "opencv-docker:${SCRIPT_VERSION}-${VERSION}" || exec_check
docker image tag "opencv-docker:${SCRIPT_VERSION}-${VERSION}" opencv-docker:latest || exec_check

show_step "Exporting image..."
docker save opencv-docker:latest -o $OUTPUT || exec_check

echo
show_step "All done."
echo
echo "To use development environment, please excute:"
echo -e "\tdocker run opencv-docker"
