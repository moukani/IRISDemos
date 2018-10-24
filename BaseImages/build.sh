#!/bin/bash
source ../ShellScriptUtils/util.sh
source ../ShellScriptUtils/buildandpush.sh

for dir in `ls -l | grep ^d. | awk '{print $NF}'`
do
    printf "\n#################################################"
    printfY "\n Building Base Image $dir"
    printf "\n#################################################\n"
    cd $dir
    ./build.sh
    
    cd ..
done