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
        cd $dir
        ./push.sh

        cd ..
    fi
done
