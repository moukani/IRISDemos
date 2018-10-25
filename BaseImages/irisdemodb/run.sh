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

#
# Help
#
function showHelp() {
    printfY "\n\nStart IRIS container locally. A folder called ./shared will be "
    printfY "\ncreated to hold shared files with the container and the durable %SYS."
    printfY "\nIf you have a license.key file, put it on this shared folder before"
    printfY "\ncalling this script."
    printf "\n\nParameters: "
    printfY "\n"
    printfY "\n\t-h | --help"
    printf "\n\tShows this help."
    printfY "\n"
    printfY "\n\t-e | --ephemeral"
    printf "\n\tCan be 'yes' or 'no' (default: yes). Warning: An ephemeral container will"
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

if [ "$isEphemeral" == "no" ]
then
    EPHEMERALFLAG=""
else
    EPHEMERALFLAG="--rm"
fi

printfY "\n\nRunning container. Management portal is on http://localhost:52773/csp/sys/UtilHome.csp\n\n"
docker run $EPHEMERALFLAG -it  \
    -p 51773:51773 -p 52773:52773 \
    -v $PWD/../../IRISLicense/:/irislicense \
    --name $CONTAINER_NAME \
    $IMAGE_NAME \
    --key /irislicense/iris.key

printfY "\nExited container\n"