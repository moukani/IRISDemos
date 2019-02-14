#!/bin/bash
#TAG=2018.1.1.642.0

#
# Parameters
#
# OLDTAG=2019.1.0.361.0
TAG=2019.2.0-stable
QUAYTAG=2019.2.0MNT.141.0

source ./util.sh

# printfY "\nDeleting old images...\n"

# docker images | grep $OLDTAG | awk '{print $3}' | xargs docker rmi -f

# printfG "\nOld images deleted.\n"

printfY "\n\nLoggin into docker.iscinternal.com (VPN Required!) to download newer images...\n"
dockerLogin docker.iscinternal.com

printfY "\n\nPulling images...\n"
for image in irishealth;
do
    docker pull docker.iscinternal.com/intersystems/$image:$QUAYTAG
    if [ $? -eq 0 ]; then 
        printfG "\nPull of docker.iscinternal.com/intersystems/$image:$QUAYTAG succesful. \n"
    else
        printfR "\nPull of docker.iscinternal.com/intersystems/$image:$QUAYTAG failed. \n"
        exit 0
    fi
done

printfY "\n\nEnter with your credentials on docker hub so we can upload the images:\n"
dockerLogin

printfY "\n\Tagging images...\n"
for image in irishealth;
do
    docker tag docker.iscinternal.com/intersystems/$image:$QUAYTAG amirsamary/irisdemo:$image.$TAG
    if [ $? -eq 0 ]; then 
        printfG "\Tagging of docker.iscinternal.com/intersystems/$image:$QUAYTAG as amirsamary/irisdemo:$image.$TAG successful\n"
    else
        printfR "\Tagging of docker.iscinternal.com/intersystems/$image:$QUAYTAG as amirsamary/irisdemo:$image.$TAG failed\n"
        exit 0
    fi
done

printfY "\n\Uploading images...\n"
for image in irishealth;
do
    docker push amirsamary/irisdemo:$image.$TAG
    if [ $? -eq 0 ]; then 
        printfG "\Pushing of amirsamary/irisdemo:$image.$TAG successful.\n"
    else
        printfR "\Pushing of amirsamary/irisdemo:$image.$TAG successful.\n"
        exit 0
    fi
done