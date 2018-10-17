#!/bin/bash

source ../../ShellScriptUtils/util.sh
source ../../ShellScriptUtils/buildandpush.sh

set -e

currentDir=${PWD##*/}

printfY "\nPushing Images for Demo $currentDir..."

# We need to start the containers so that my next command work
docker-compose up -d 

commands=$(docker-compose images | awk -v pat="^$currentDir" '$0~pat{ print "docker push " $2 ":" $3 }')

# Now we have the list of commands with images to push
docker-compose stop

echo "*************"

IFS=$'\n'
for command in $commands; do
    echo
    printfY $command
    echo
    eval $command
done