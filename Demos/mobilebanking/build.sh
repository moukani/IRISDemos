#!/bin/bash

source ../../ShellScriptUtils/util.sh
source ../../ShellScriptUtils/buildandpush.sh

set -e

printfY "\nUpdating sub modules...\n"
git submodule update --remote

printfY "\nBUILDING...\n"
docker-compose build --force-rm --no-cache

printfY "\n\nRUNNING...\n"
docker-compose up