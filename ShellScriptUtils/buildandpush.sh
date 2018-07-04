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
#   3- With two parameters, where the first is "pushcontainer" and the second is a code to
#      be executed on the temp container before it is commited and pushed to the repository.
#
function buildAndPush() {

    # The image name will be named after the folder of the Dockerfile
    IMAGE_NAME=amirsamary/irisdemo:${PWD##*/}

    #docker rmi -f $IMAGE_NAME

    printfY "\n\nBuilding image ${IMAGE_NAME}...\n\n"
    docker build --force-rm -t $IMAGE_NAME . 
    checkError "\n\nImage ${IMAGE_NAME} failed to build!\n\n" "\n\nImage ${IMAGE_NAME} built!\n\n"

    if [ "$1" == "pushcontainer" ]
    then
        printfY "\n\nCreating container based on image...\n\n"
        docker stop tempcontainer > /dev/null
        docker rm tempcontainer > /dev/null
        # Must not use --rm flag on this docker run because I need it to continue to exist
        # after I stop it so I can commit it
        docker run -d \
            --name tempcontainer \
            $IMAGE_NAME
        checkError "ERROR: Could not create temp container for image ${IMAGE_NAME}!" "Temp container created and running..."

        sleep 5
        
        # Do we have to run something on the container?
        if [ ! "$2" == "" ]
        then
            printfY "\n\nExecuting $2...\n\n"
            docker exec -it tempcontainer $2
            checkError "ERROR: Error when executing $2 on temp container!" "Done!"
        fi

        printfY "\n\nStop temp container...\n\n"
        docker stop tempcontainer
        checkError "ERROR: Could not stop temp container!" "Temp container stopped..."

        printfY "\n\nCommiting temp container...\n\n"
        docker commit tempcontainer $IMAGE_NAME
        checkError "ERROR: Could not commit temp container!" "Temp container commited!"
    fi

    if [ \( "$1" == "push" \) -o \( "$1" == "pushcontainer" \) ]
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