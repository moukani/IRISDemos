#!/bin/bash
source ../ShellScriptUtils/util.sh
source ../ShellScriptUtils/buildandpush.sh

for dir in `ls -l | grep ^d. | awk '{print $NF}'`
do
    if [[ ! $dir =~ (templates|mydemo) ]]
    then
        printfY "\nBuilding Images for Demo $dir..."
        cd $dir
        ./build.sh
    
        cd ..
    fi
done