#!/bin/bash

source ../../ShellScriptUtils/util.sh
source ../../ShellScriptUtils/buildandpush.sh

if [ -z "$1" ]
then
    buildAndPush
else
    buildAndPush $1
fi