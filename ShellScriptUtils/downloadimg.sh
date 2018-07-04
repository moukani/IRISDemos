#!/bin/bash
#TAG=2018.1.1.642.0

#
# Parameters
#
OLDTAG=2018.2.0.387.0
TAG=2018.2.0-stable

source ./common/util.sh

printfY "\nDeleting old images...\n"

docker images | grep $OLDTAG | awk '{print $3}' | xargs docker rmi -f

printfG "\nOld images deleted.\n"

printfY "\n\nLoggin into docker.iscinternal.com (VPN Required!) to download newer images...\n"
dockerLogin docker.iscinternal.com

printfY "\n\nPulling images...\n"
for image in icm iris arbiter webgateway;
do
    docker pull docker.iscinternal.com/intersystems/$image:$TAG
    if [ $? -eq 0 ]; then 
        printfG "\nPull of docker.iscinternal.com/intersystems/$image:$TAG succesful. \n"
    else
        printfR "\nPull of docker.iscinternal.com/intersystems/$image:$TAG failed. \n"
        exit 0
    fi
done

printfY "\n\nEnter with your credentials on docker hub so we can upload the images:\n"
dockerLogin

printfY "\n\Tagging images...\n"
for image in icm iris arbiter webgateway;
do
    docker tag docker.iscinternal.com/intersystems/$image:$TAG amirsamary/irisdemo:$image.$TAG
    if [ $? -eq 0 ]; then 
        printfG "\Tagging of docker.iscinternal.com/intersystems/$image:$TAG as amirsamary/irisdemo:$image.$TAG successful\n"
    else
        printfR "\Tagging of docker.iscinternal.com/intersystems/$image:$TAG as amirsamary/irisdemo:$image.$TAG failed\n"
        exit 0
    fi
done

printfY "\n\Uploading images...\n"
for image in icm iris arbiter webgateway;
do
    docker push amirsamary/irisdemo:$image.$TAG
    if [ $? -eq 0 ]; then 
        printfG "\Pushing of amirsamary/irisdemo:$image.$TAG successful.\n"
    else
        printfR "\Pushing of amirsamary/irisdemo:$image.$TAG successful.\n"
        exit 0
    fi
done

printfY "\n\Starting a Temp IRIS container so we can extract the lates JAR files...\n"
docker run -d --name TEMPIRIS amirsamary/irisdemo:iris.$TAG
if [ $? -eq 0 ]; then 
    printfG "\Temp container running. Ready for extracting jar files...\n"
else
    printfR "\Could not start temp container for extraction of jar files!\n"
    exit 0
fi

printfY "\n\Removing old jar files...\n"
rm -f ./containers/common/lib/iris/*

printfY "\n\Extracting jar files from temp container...\n"
docker cp TEMPIRIS:/usr/irissys/dev/java/lib/JDK18/. ./containers/common/lib/iris/
if [ $? -eq 0 ]; then 
    printfG "\File extracted successfully!\n"
else
    printfR "\Could not extract the jar files!\n"
    exit 0
fi

printfY "\n\Stopping Temp container...\n"
docker stop TEMPIRIS

printfY "\n\Removing Temp container...\n"
docker rm TEMPIRIS
