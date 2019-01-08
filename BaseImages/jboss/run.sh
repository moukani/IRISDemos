#!/bin/bash
#
# This script is just to test the container. You should NOT start it with
# Durable %SYS!
#
# Amir Samary - 2018

source ../../ShellScriptUtils/util.sh

# Constants:
CONTAINER_NAME=${PWD##*/}
# The name of the image is based on the name of the folder
IMAGE_NAME=amirsamary/irisdemo:${PWD##*/}

printfY "\n\nRunning container. Listening on http://localhost:8080/ and on http://localhost:9990/\n"
docker run --rm -it  \
    -p 8080:8080  \
    -p 9990:9990  \
    -e IRIS_MASTER_USERNAME=SuperUser \
    -e IRIS_MASTER_PASSWORD=sys \
    -e IRIS_MASTER_HOST=localhost \
    -e IRIS_MASTER_PORT=51773 \
    -e IRIS_MASTER_NAMESPACE=APP \
    --name $CONTAINER_NAME \
    $IMAGE_NAME

printfY "\nExited container\n"