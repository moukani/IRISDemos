#!/bin/bash

source ../../ShellScriptUtils/util.sh
source ../../ShellScriptUtils/buildandpush.sh

set -e

printfY "\nUpdating sub modules...\n"
git submodule init
git submodule update

printfY "\nStopping and removing old containers...\n"
docker-compose stop
docker-compose rm -f
rm -rf ./advanced_analytics/shared/zeppelin/conf
rm -rf ./advanced_analytics/shared/zeppelin/logs

printfY "\nVerifying if there are new changes...\n"
git pull
if [ "$?" -gt "0" ]
then
    printfY "\nBUILDING...\n"
    docker-compose build
fi

startAndCheckContainers