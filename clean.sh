#!/bin/bash

if ! source $1 1> /dev/null 2> /dev/null; then
    echo "ERROR: Wrong config." >&2
    echo "Usage: clean.sh CONFIG_PATH"
    exit -3
fi

echo "OpenCV-Docker Clean Script ${SCRIPT_VERSION}"
rm -rf "build"
rm -rf "opencv-${VERSION}"
rm -rf "opencv_contrib-${VERSION}"
rm "opencv-${VERSION}.zip"
rm "opencv_contrib-${VERSION}.zip"
rm $OUTPUT
echo
echo "Finished."