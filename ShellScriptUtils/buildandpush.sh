#!/bin/bash
#
# Amir Samary - 2018
#
# Three ways of calling:
#
#   1- Without parameters: It will simply build the container, not push it to the registry.
#   2- With one parameter that can be "push" or "pushcontainer". If run with push, it will 
#      build the container and push it to the registry. If run with pushcontainer, it will
#      build the container, start it, commit it and pushed the committed image instead.
#   3- With more than one parameter. The second parameter and all others that follow are
#      passed to docker build command.
#
function buildAndPush() {

    # The image name will be named after the folder of the Dockerfile
    IMAGE_NAME=amirsamary/irisdemo:${PWD##*/}

    printfY "\n\nBuilding image ${IMAGE_NAME}...\n\n"
    if [ "$1" == "push" ]
    then
        params=${@:2:${#}}
        printf "\ndocker build ${params} --force-rm -t $IMAGE_NAME .\n"
        docker build ${params} --force-rm -t $IMAGE_NAME .
        checkError "\n\nImage ${IMAGE_NAME} failed to build!\n\n" "\n\nImage ${IMAGE_NAME} built!\n\n"
    else
        params=${@:1:${#}}
        printf "\ndocker build ${params} --force-rm -t $IMAGE_NAME . \n"
        docker build ${params} --force-rm -t $IMAGE_NAME . 
        checkError "\n\nImage ${IMAGE_NAME} failed to build!\n\n" "\n\nImage ${IMAGE_NAME} built!\n\n"
    fi

    if [ "$1" == "push" ]
    then
        dockerLogin

        printfY "\n\nPushing image ${IMAGE_NAME} to docker hub...\n\n"
        docker push $IMAGE_NAME
        checkError "ERROR: Image ${IMAGE_NAME} failed to be pushed to docker hub!" "Image ${IMAGE_NAME} pushed to docker!"
    else
        printfY "\n\nImage ${IMAGE_NAME} NOT pushed to docker hub. If you want to push it, run the following command now:"
        printf "\n\n\tdocker push $IMAGE_NAME"
        printfY "\n\nOr call the build.sh script again passing the push parameter.\n\n"
    fi
}