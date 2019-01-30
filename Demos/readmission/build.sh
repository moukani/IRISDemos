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
printfY "\nRemoving zeppelin configuration (you may be required to enter with your sudo password)...\n"
sudo rm -rf ./advanced_analytics/shared/zeppelin/conf
sudo rm -rf ./advanced_analytics/shared/zeppelin/logs
printfY "\nBuilding...\n"
docker-compose build