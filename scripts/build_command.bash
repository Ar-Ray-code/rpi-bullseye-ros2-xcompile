#!/bin/bash
INSTALL_NAME="built_pkg_rpi"
DISTRO="iron"

source /opt/ros/${DISTRO}/setup.bash
colcon build --build-base build_${INSTALL_NAME} --install-base ${INSTALL_NAME} --cmake-clean-cache --merge-install --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-march=armv8-a+crc -mtune=cortex-a72 -O3" -DCMAKE_C_FLAGS="-march=armv8-a+crc -mtune=cortex-a72 -O3"
if [ $? -ne 0 ]; then
    echo "colcon build failed"
    exit 1
fi

UNIXTIME=$(date +%s)
zip -rq ${INSTALL_NAME}_${UNIXTIME}.zip ${INSTALL_NAME}
if [ $? -ne 0 ]; then
    echo "zip failed"
    exit 1
fi

echo ""
echo "build success and compressed to ${INSTALL_NAME}_${UNIXTIME}.zip 📦"
echo ""
