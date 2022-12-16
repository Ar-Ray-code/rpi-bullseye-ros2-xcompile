#!/bin/bash
ROS2_WS=$1
OPERATE_BASH=$2

ROS2_WS=`realpath ${ROS2_WS}`/
DOCKER_NAME="rpi4-ros2"

DEB_ROOT=${ROS2_WS}/deb/

SCRIPT_DIR=$(
    cd $(dirname $0)
    pwd
)

if [ -z ${ROS2_WS} ]; then
    # ROS2_WS=${SCRIPT_DIR}/mnt
    echo "Please enter the ROS2 workspace path as the first parameter."
    echo ""
    echo "Usage:"
    echo "- xcompile_rpi_ros2 [ROS2_WS] [OPERATE_BASH (optional)]"
    echo ""
    
    exit 1
fi

sudo echo "permission check... OK!"


cd $SCRIPT_DIR

if [ -z ${OPERATE_BASH} ]; then
    OPERATE_BASH=${SCRIPT_DIR}/scripts/build_command.bash
fi


# is this directory?
if [ ! -d ${ROS2_WS} ]; then
    echo "ROS2_WS is not a directory."
    echo "Please create a valid ROS2 workspace."
    echo ""
    echo "mkdir -p ${ROS2_WS}/src"
    echo ""
    exit 1
fi
mkdir -p ${ROS2_WS}
ROS2_WS=$(cd ${ROS2_WS}; pwd)
OPERATE_BASH=$(cd $(dirname ${OPERATE_BASH}); pwd)/$(basename ${OPERATE_BASH})

echo ""
echo "========== Build summary =========="
echo "ROS2_WS: ${ROS2_WS}"
echo "run bash: ${OPERATE_BASH}"
echo "==================================="
sleep 3

# if docker is not installed
if ! [ -x "$(command -v docker)" ]; then
    sudo apt update
    sudo apt install -y ca-certificates curl gnupg lsb-release

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io

    sudo groupadd docker
    sudo usermod -aG docker ${USER}
    newgrp docker
fi

# setup qemu (if this computer arch is x86_64)
if [ "$(uname -m)" == "x86_64" ]; then
    docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
fi

# build docker and run
docker build -t ${DOCKER_NAME} ${SCRIPT_DIR}/.

BASH_SCRIPT_CONTENT=$(cat ${OPERATE_BASH})
docker run -it --rm --init --privileged --network=host -v ${ROS2_WS}:/ros2_ws ${DOCKER_NAME} /bin/bash -c "${BASH_SCRIPT_CONTENT}"

# create deb package


if [ $? -ne 0 ]; then
    echo "docker run failed"
    exit 1
fi

sudo chown -R ${USER}:${USER} ${ROS2_WS}
unset SCRIPT_DIR

echo "" && echo ""
echo "All done. Thank you! 🍓📦🐢"
echo "========================================"
echo "📦 GitHub         : https://github.com/Ar-Ray-code/rpi-bullseye-ros2-xcompile"
echo "🐞 Bug report     : https://github.com/Ar-Ray-code/rpi-bullseye-ros2-xcompile/issues"
echo "🧡 GitHub sponsor : https://github.com/sponsors/Ar-Ray-code"
echo "========================================"
echo ""
