#!/bin/bash

source ../../ShellScriptUtils/util.sh
source ../../ShellScriptUtils/buildandpush.sh

printfY "\nRunning docker compose..."

docker-compose up --build