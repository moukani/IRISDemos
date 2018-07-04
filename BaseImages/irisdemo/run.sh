#!/bin/bash
#
# This script is just to test the container and work locally on the notebooks
# that will be cooked into the container when we re-build the image
#
# Amir Samary - 2018

source ../../ShellScriptUtils/util.sh

# Constants:
CONTAINER_NAME=irisdemo
# The name of the image is based on the name of the folder
IMAGE_NAME=amirsamary/irisdemo:${PWD##*/}

#
# Help
#
function showHelp() {
    printfY "\n\nStart IRIS container locally. A folder called ./shared will be "
    printfY "\ncreated to hold shared files with the container and the durable %SYS."
    printf "\n\nParameters: "
    printfY "\n"
    printfY "\n\t-h | --help"
    printf "\n\tShows this help."
    printfY "\n"
    printfY "\n\t-e | --ephemeral"
    printf "\n\tCan be 'yes' or 'no' (default: no). Warning: An ephemeral container will"
    printf "\n\thave a different hostname each time it is started. Unless you are using"
    printf "\n\tDocker compose to build it."
    printfY "\n"
}
#
# Main
#

for param in "$@"
do
    case $param in
        -h|--help)
        showHelp
        exit 0
        shift 
        ;;
        -e=*|--ephemeral=*)
        isEphemeral="${param#*=}"
        shift 
        ;;
        *)
            # unknown option
        ;;
    esac
done

#
# By using --rm flag when starting the container, it will remove the container before
# starting it if it already exists. It will also remove the container after we quit it.
# This is what is called an "ephemeral container".
#
if [ ! -d ./shared ]
then
    mkdir ./shared
fi

if [ "$isEphemeral" == "yes" ]
then
    EPHEMERALFLAG="--rm"
else
    EPHEMERALFLAG=""
fi

printfY "\n\nRunning container...\n"
docker run $EPHEMERALFLAG -it  \
    -p 51772:51772 -p 52772:52772 \
    -v $PWD/shared:/shared \
    --name $CONTAINER_NAME \
    $IMAGE_NAME

printfY "\nExited container\n"