#Powershell script
#
# This script is just to test the container. You should NOT start it with
# Durable %SYS!
#
# Jose-Tomas Salvador - Oct 2018
# Based on run.sh script by Amir Samary - 2018

param([string]$ephemeral="yes")

. ../../PWSscriptUtils/util.ps1

# Constants:
$CONTAINER_NAME = Split-Path -Leaf (get-location)
# The name of the image is based on the name of the folder
$IMAGE_NAME=("amirsamary/irisdemo:"+(Split-Path -Leaf (get-location)))
$EPHEMERALFLAG="--rm"
$dirCurrent=(get-location)

#For test
#write-host ("Parameters: " + $ephemeral + " *** args: " + $args) 
#
# Help
#
function showHelp() {
    Write-Host -F Yellow "Start IRIS container locally. A folder called ./shared will be "
    Write-Host -F Yellow "created to hold shared files with the container and the durable %SYS."
    Write-Host -F Yellow "If you have a license.key file, put it on this shared folder before"
    Write-Host -F Yellow "calling this script."
    Write-Host "`nParameters: "
    Write-Host -F Yellow ""
    Write-Host -F Yellow "`t-h | --help"
    Write-Host "`tShows this help."
    Write-Host -F Yellow ""
    Write-Host -F Yellow "`t-e | --ephemeral"
    Write-Host "`tCan be 'yes' or 'no' (default: yes). Warning: An ephemeral container will"
    Write-Host "`thave a different hostname each time it is started. Unless you are using"
    Write-Host "`tDocker compose to build it."
    Write-Host -F Yellow ""
}
#
# Main
#
$ephemeral = $ephemeral.ToLower()

#If script is called with -h or --help, it'll be stored in $ephemeral
if (($ephemeral -eq "--help") -or ($ephemeral -eq "-h"))
{
    showHelp
    exit 0
}

if (($ephemeral -eq "no") -or ($ephemeral -eq "n"))
{
    $EPHEMERALFLAG=""
}


#
# By using --rm flag when starting the container, it will remove the container before
# starting it if it already exists. It will also remove the container after we quit it.
# This is what is called an "ephemeral container".
#
if (! (Test-Path ./shared)) 
{
    mkdir ./shared
}

Write-Host -F Yellow "Running container. Management portal is on http://localhost:5273/csp/sys/UtilHome.csp `n"
docker run $EPHEMERALFLAG -it  `
    -p 5173:51773 -p 5273:52773 `
    -v $dirCurrent\shared:/shared `
    -v $dirCurrent\..\..\IRISLicense:/irislicense `
    --name $CONTAINER_NAME `
    $IMAGE_NAME `
    --key /irislicense/iris.key

Write-Host -F Yellow "Exited container"