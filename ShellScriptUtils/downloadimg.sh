#!/bin/bash
#TAG=2018.1.1.642.0

#
# Parameters
#
OLDTAG=2018.2.0.389.0
TAG=2018.2.0-stable

source ./util.sh

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

printfY "\n\nPulling 2018.1.1 image so we can extract iKnow related resources from it...\n"
docker pull docker.iscinternal.com/intersystems/iris:2018.1.1-stable
if [ $? -eq 0 ]; then 
    printfG "\nPull of docker.iscinternal.com/intersystems/iris:2018.1.1-stable succesful. \n"
else
    printfR "\nPull of docker.iscinternal.com/intersystems/iris:2018.1.1-stable failed. \n"
    exit 0
fi

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

docker tag docker.iscinternal.com/intersystems/iris:2018.1.1-stable amirsamary/irisdemo:iris.2018.1.1-stable
if [ $? -eq 0 ]; then 
    printfG "\Tagging of docker.iscinternal.com/intersystems/iris:2018.1.1-stable as amirsamary/irisdemo:iris.2018.1.1-stable successful\n"
else
    printfR "\Tagging of docker.iscinternal.com/intersystems/iris:2018.1.1-stable as amirsamary/irisdemo:iris.2018.1.1-stable failed\n"
    exit 0
fi

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

docker push amirsamary/irisdemo:iris.2018.1.1-stable
if [ $? -eq 0 ]; then 
    printfG "\Pushing of amirsamary/irisdemo:iris.2018.1.1-stable successful.\n"
else
    printfR "\Pushing of amirsamary/irisdemo:iris.2018.1.1-stable successful.\n"
    exit 0
fi