#!/bin/bash
source ../ShellScriptUtils/util.sh
source ../ShellScriptUtils/buildandpush.sh

printfG "\nBuilding Base Images"
cd ./BaseImages
./build.sh
cd ..

printfG "\nBuilding Demos"
cd ./Demos
./build.sh
cd ..
