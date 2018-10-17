#!/bin/bash
source ../ShellScriptUtils/util.sh
source ../ShellScriptUtils/buildandpush.sh

if [ ! -z "$DOCKERLOGINDONE" ]
then
    dockerLogin
    export DOCKERLOGINDONE=1
fi

for dir in `ls -l | grep ^d. | awk '{print $NF}'`
do
    IMAGE_NAME=amirsamary/irisdemo:$dir

    printfY "\n\nPushing image ${IMAGE_NAME} to docker hub...\n\n"
    docker push $IMAGE_NAME
    checkError "ERROR: Image ${IMAGE_NAME} failed to be pushed to docker hub!" "Image ${IMAGE_NAME} pushed to docker!"
done
