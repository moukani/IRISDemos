#!/bin/bash

IRIS_PROJECT_FOLDER_NAME=mydb-atelier-project

source ../../../ShellScriptUtils/util.sh
source ../../../ShellScriptUtils/buildandpush.sh

if [ -z "$1" ]
then
    buildAndPush --build-arg IRIS_PROJECT_FOLDER_NAME=$IRIS_PROJECT_FOLDER_NAME
else
    buildAndPush $1 --build-arg IRIS_PROJECT_FOLDER_NAME=$IRIS_PROJECT_FOLDER_NAME
fi