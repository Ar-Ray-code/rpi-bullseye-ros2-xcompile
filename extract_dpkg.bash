#!/bin/bash
check_and_exit() {
    if [ $? -ne 0 ]; then
        echo "failed"
        exit 1
    fi
}

SCRIPT_DIR=`realpath $(dirname "$0")`
TARGET_USER_LOCAL_DIR=${1:-$SCRIPT_DIR/extracted_dpkg/usr/local}
TARGET_USER_OPT_DIR=${2:-$SCRIPT_DIR/extracted_dpkg/opt}
TARGET_DPKG_DIR=${2:-$SCRIPT_DIR/dpkg}

# create dir
mkdir -p $TARGET_USER_LOCAL_DIR

DPKGS=""
for file in `ls $TARGET_DPKG_DIR`; do
    DPKGS="$DPKGS /home/user/dpkg/$file"
done
check_and_exit
echo "dpkgs: $DPKGS"

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

# force install (no depends)
docker run -it --rm \
    -v $TARGET_USER_LOCAL_DIR:/usr/local \
    -v $TARGET_USER_OPT_DIR:/opt \
    -v $TARGET_DPKG_DIR:/home/user/dpkg \
    -v $SCRIPT_DIR:/home/user/script \
    arm64v8/debian:bookworm \
    /bin/bash -c "dpkg -i --force-all $DPKGS"
check_and_exit
