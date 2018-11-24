#!/bin/bash
#
# Amir: I used this script to delete all the images on my PC. 
# Then I would use ./downloadimg.sh to downloaded the latest stable 2018.2 images from 
# our internal Docker Registry. 
# As I deleted all the images before, I am now sure that I am using the latest IRIS images to build the demos.
#
# When we have our IRIS Images published on Docker Hub, we will make this open source and configure
# a CI pipeline to get these images built automatically on each new IRIS build.
#
for image in $(docker images | grep amirsamary/irisdemo | awk '{print $3}')
do
    docker rmi -f $image
done

docker system prune