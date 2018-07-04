#!/bin/bash
#
# This script is just to test the container and work locally on the notebooks
# that will be cooked into the container when we re-build the image
#
# Amir Samary - 2018

source ../../ShellScriptUtils/util.sh

# Constants:
CONTAINER_NAME=tomcat
# The name of the image is based on the name of the folder
IMAGE_NAME=amirsamary/irisdemo:${PWD##*/}

#
# Help
#
function showHelp() {
    printfY "\n\nStart Tomcat container locally, configured to connect to an IRIS server"
    printfY "\nthrough JDBC and/or Spark. A folder called ./shared will be "
    printfY "\ncreated to hold the custom configurations and Tomcat notebook files."
    printf "\n\nParameters: "
    printfY "\n"
    printfY "\n\t-h | --help"
    printf "\n\tShows this help."
    printfY "\n"
    printfY "\n\t-e | --ephemeral"
    printf "\n\tCan be 'yes' or 'no' (default: no). Warning: An ephemeral container will"
    printf "\n\thave a different hostname each time it is started. The configuration files"
    printf "\n\tgenerated on the durable ./shared will need to be deleted so they"
    printf "\n\tcan be regenerated with the new hostname."
    printfY "\n"
    printfY "\n\t-s | --server"
    printf "\n\tIP of IRIS Server (default: your local IP)."
    printfY "\n"
    printfY "\n\t-p | --port"
    printf "\n\tIRIS Super server Port (default: 1973)."
    printfY "\n"
    printfY "\n\t-u | --user"
    printf "\n\tUser name to connect with (default: SuperUser)."
    printfY "\n"
    printfY "\n\t-p | --password"
    printf "\n\tPassword (default: sys)."
    printfY "\n"
    printfY "\n\t-n | --namespace"
    printf "\n\tNamespace (default: APP)."
    printfY "\n\n"
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
        -s=*|--server=*)
        IRIS_MASTER_HOST="${param#*=}"
        shift # past argument=value
        ;;
        -p=*|--port=*)
        IRIS_MASTER_PORT="${param#*=}"
        shift # past argument=value
        ;;
        -u=*|--user=*)
        IRIS_MASTER_USERNAME="${param#*=}"
        shift # past argument=value
        ;;
        -n=*|--namespace=*)
        IRIS_MASTER_NAMESPACE="${param#*=}"
        shift # past argument=value
        ;;
        -pw=*|--password=*)
        IRIS_MASTER_PASSWORD="${param#*=}"
        shift # past argument=value
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

if [ -z "$IRIS_MASTER_HOST" ]
then
    IRIS_MASTER_HOST=$(ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}')
fi

if [ -z "$IRIS_MASTER_PORT" ]
then
    IRIS_MASTER_PORT=1973
fi

if [ -z "$IRIS_MASTER_NAMESPACE" ]
then
    IRIS_MASTER_NAMESPACE="APP"
fi

if [ -z "$IRIS_MASTER_USERNAME" ]
then
    IRIS_MASTER_USERNAME="SuperUser"
fi

if [ -z "$IRIS_MASTER_PASSWORD" ]
then
    IRIS_MASTER_PASSWORD="sys"
fi

printfY "\n\nContainer will be started and configured to connect to iris on $IRIS_MASTER_HOST:$IRIS_MASTER_PORT/$IRIS_MASTER_NAMESPACE with user $IRIS_MASTER_USERNAME...\n\n"

printfY "\n\nRunning container... In a couple of seconds, Tomcat should be available on http://localhost:9090/\n"
docker run $EPHEMERALFLAG -it  \
    -p 8080:8080 \
    -v $PWD/shared:/shared \
    -e IRIS_MASTER_HOST=$IRIS_MASTER_HOST \
    -e IRIS_MASTER_PORT=$IRIS_MASTER_PORT \
    -e IRIS_MASTER_USERNAME=$IRIS_MASTER_USERNAME \
    -e IRIS_MASTER_PASSWORD=$IRIS_MASTER_PASSWORD \
    -e IRIS_MASTER_NAMESPACE=$IRIS_MASTER_NAMESPACE \
    --name $CONTAINER_NAME \
    $IMAGE_NAME

printfY "\nExited container\n"