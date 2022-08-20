#!/bin/bash

if ! source $1 1> /dev/null 2> /dev/null; then
    echo "WARNING: No config." >&2
    echo "Usage: clean.sh [CONFIG_PATH]"
    echo "Now using default: Configs/linux-docker/build.cfg"
    echo
    source Configs/linux-docker/build.cfg
fi

function rm_ifsudo() {
    if ! rm -rf "$1"; then
        echo "Failed to clean without sudo."
        sudo rm -rf "$1"
    fi
}

echo "OpenCV-Docker Clean Script ${SCRIPT_VERSION}"
rm_ifsudo "build"
rm_ifsudo "opencv-${VERSION}"
rm_ifsudo "opencv_contrib-${VERSION}"
rm "opencv-${VERSION}.zip"
rm "opencv_contrib-${VERSION}.zip"
rm $OUTPUT
docker system prune --all
echo
echo "Finished."