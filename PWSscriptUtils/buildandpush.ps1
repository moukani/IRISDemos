#!
# Jose-Tomas Salvador - Oct-2018
# Based on script for Unix shell by Amir Samary - Sep 2018
#
# Three ways of calling:
#
#   1- Without parameters: It will simply build the container, not push it to the registry.
#   2- With one parameter that can be "push" or "pushcontainer". If run with push, it will 
#      build the container and push it to the registry. If run with pushcontainer, it will
#      build the container, start it, commit it and pushed the committed image instead.
#   3- With more than one parameter. The second parameter and all others that follow are
#      passed to docker build command.
#
function buildAndPush
 {
  $currDir = split-path -leaf (pwd)
  $IMAGE_NAME="amirsamary/irisdemo:$currDir"
  #Filename to use as Dockerfile. By default Dockerfile in current path
  #But if Dockerfile.win exists, it uses this one
  $DockerFile = "."
  if (test-path ./Dockerfile.win) {$DockerFile = "./Dockerfile.win"}

  write-host "`n Building image $IMAGE_NAME...using Dockerfile in: $Dockerfile `n"

  #split arguments. $first will store the first one, $rest the remaining 
  $first, $rest = $args

  #param could be push or pushcontainer, in both cases we have to take it away before calling docker build
  if ($first -like "push") 
  {
      $params=$rest
  }
  else
  {
      $params=$first,$rest
  }

  #foreach ($par in $params)  {  write-host "`n param:"$par }

  $ErrorActionPreference = "stop"
  try 
  {
    write-host "`n docker build $params --force-rm -t $IMAGE_NAME . "
    docker build $params --force-rm -t $IMAGE_NAME -f $DockerFile . 2>$null
    write-host -F Green  "`nImage $IMAGE_NAME built!"
  }
  catch
  {
    $errormessage = $_.TargetObject
    write-host -F Yellow "ERROR : $errormessage"
    write-host -F Red "`nImage $IMAGE_NAME failed to build!`n"
    return
  }

  #Just push the container if explicitely indicated
  if ($first -eq "push")
  {
      try 
      {
        Write-Host "`n LLAMADA CON PUSH"
        dockerLogin 2>$null

        write-host -F Yellow "`nPushing image $IMAGE_NAME to docker hub...`n"
        docker push $IMAGE_NAME 2>$null
        write-host -F Green "`nImage $IMAGE_NAME pushed to docker!"
      }
      catch
      {
        $errormessage = $_.TargetObject
        write-host -F Yellow "ERROR : $errormessage"
        write-host -F Red "ERROR: Image $IMAGE_NAME failed to be pushed to docker hub!"
        return
      }
  }
  else
  {
      write-host -F Yellow "`nImage $IMAGE_NAME NOT pushed to docker hub. If you want to push it, run the following command now:"
      write-host "`tdocker push $IMAGE_NAME"
      write-host -F Yellow "Or call the build.ps1 script again passing the push parameter.`n"
  }
}
