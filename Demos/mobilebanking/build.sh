#!/bin/bash

source ../../ShellScriptUtils/util.sh
source ../../ShellScriptUtils/buildandpush.sh

set -e

printfY "\nUpdating sub modules...\n"
git submodule init
git submodule update

printfY "\nBUILDING...\n"
docker-compose stop
docker-compose rm -f
rm -rf ./advanced_analytics/shared/zeppelin/conf
rm -rf ./advanced_analytics/shared/zeppelin/logs
docker-compose build