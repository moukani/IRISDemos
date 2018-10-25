#!/bin/bash

source ../ShellScriptUtils/util.sh
source ../ShellScriptUtils/buildandpush.sh

if [ ! -z "$DOCKERLOGINDONE" ]
then
    dockerLogin
    export DOCKERLOGINDONE=1
fi

for dir in `ls -l | grep ^d. | awk '{print $NF}'`
do
    if [[ ! $dir =~ (templates|mydemo) ]]
    then
        printfY "\n#################################################"
        printfY "\n Pushing Demo $dir"
        printfY "\n#################################################\n"

        cd $dir
        docker-compose push

        cd ..
    fi
done
