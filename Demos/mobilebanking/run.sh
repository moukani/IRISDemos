#!/bin/bash

source ../../ShellScriptUtils/util.sh
source ../../ShellScriptUtils/buildandpush.sh

set -e

printfY "\nUpdating sub modules...\n"
git submodule init
git submodule update

printfY "\n\nStopping and deleting previous containers...\n"
docker-compose stop
docker-compose rm -f

startAndCheckContainers