# Jose-Tomas Salvador - Oct-2018
# Based on script for Unix of Amir Samary - Sep 2018<#

$IRIS_PROJECT_FOLDER_NAME="irisdemodb-atelier-project"

. ../../PWSscriptUtils/util.ps1
. ../../PWSscriptUtils/buildandpush.ps1

if ($args.Count -eq 0)
{
  buildAndPush --build-arg IRIS_PROJECT_FOLDER_NAME=$IRIS_PROJECT_FOLDER_NAME
}
else 
{
  buildAndPush $args[0] --build-arg IRIS_PROJECT_FOLDER_NAME=$IRIS_PROJECT_FOLDER_NAME
}