#!/bin/bash

source ../../ShellScriptUtils/util.sh
source ../../ShellScriptUtils/buildandpush.sh

printfY "\nUpdating sub modules...\n"
git submodule init
git submodule update

printfY "\nBuilding Hibernate Dialect Jar file on base image...\n"
source ./hibernate.build.sh

if [ -z "$1" ]
then
    buildAndPush
else
    buildAndPush $1
fi