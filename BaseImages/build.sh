#!/bin/bash
source ../ShellScriptUtils/util.sh
source ../ShellScriptUtils/buildandpush.sh

for dir in `ls -l | grep ^d. | awk '{print $NF}'`
do
    cd $dir
    ./build.sh
    
    cd ..
done