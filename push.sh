#!/bin/bash
source ./ShellScriptUtils/util.sh
source ./ShellScriptUtils/buildandpush.sh

printfG "\nPushing Base Images"
cd ./BaseImages
./push.sh
cd ..

printfG "\nPushing Demos"
cd ./Demos
./push.sh
cd ..
