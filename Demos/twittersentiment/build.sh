#!/bin/bash

source ../../ShellScriptUtils/util.sh
source ../../ShellScriptUtils/buildandpush.sh

set -e

printfY "\nUpdating sub modules...\n"
git submodule init
git submodule update

printfY "\nStopping containers (if they are running)...\n"
docker-compose stop

printfY "\nRemoving previous containers (if they are there)...\n"
docker-compose rm -f

printfY "\nCopying iris.key license to the context of twittersentiment image (we should rewrite this in order this is not necessary)...\n"
cp ../../IRISLicense/iris.key ./twittersentiment/

printfY "\nRemoving zeppelin configuration (you may be required to enter with your sudo password)...\n"
sudo rm -rf ./advanced_analytics/shared/zeppelin/conf
sudo rm -rf ./advanced_analytics/shared/zeppelin/logs

printfY "\nBuilding new images...\n"
docker-compose build
