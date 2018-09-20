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

printfY "\n\nRunning container. Listening on http://localhost:4200/\n"
docker run --rm -it  \
    -p 4200:4200  \
    --name $CONTAINER_NAME \
    $IMAGE_NAME

printfY "\nExited container\n"