#!/bin/bash


check_and_exit() {
    if [ $? -ne 0 ]; then
        echo "failed"
        exit 1
    fi
}


SCRIPT_DIR=`realpath $(dirname "$0")`
cd ${SCRIPT_DIR}

TARGET_DOCKERFILE=$1
if [ ! -f "$TARGET_DOCKERFILE" ]; then
    echo "Usage: $ ./create_image.bash <target_dockerfile.dockerfile> "
    exit 1
fi

if [ ! -f "$TARGET_DOCKERFILE" ]; then
    echo "Error: Dockerfile not found at $TARGET_DOCKERFILE"
    exit 1
fi

if [ ! -s "$TARGET_DOCKERFILE" ]; then
    echo "Error: Dockerfile is empty."
    exit 1
fi

NAME=$(basename $(echo "$TARGET_DOCKERFILE" | sed 's/\.dockerfile//'))
DATE=`date +'%Y%m%d'`

echo "tag: ${NAME}:${DATE} (target: ${TARGET_DOCKERFILE})"

docker build -t ${NAME}:${DATE} -f ${TARGET_DOCKERFILE} .
check_and_exit

docker save -o ${NAME}_${DATE}.tar ${NAME}:${DATE}
check_and_exit
