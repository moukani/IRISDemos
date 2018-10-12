#!/bin/bash

source ../../ShellScriptUtils/util.sh
source ../../ShellScriptUtils/buildandpush.sh

set -e

currentDir=${PWD##*/}

commands=$(docker-compose images | awk -v pat="^$currentDir" '$0~pat{ print "docker push " $2 ":" $3 }')

echo "*************"

IFS=$'\n'
for command in $commands; do
    echo
    printfY $command
    echo
    eval $command
done