<#
  Function Library
#
# Jose-Tomas Salvador - Oct-2018
# Based on script by Amir Samary for Shell - Sep-2018 

# This script is included on practically all other scripts
#
# Utility functions
#>

function showError($err) {
  write-host -ForegroundColor red "ERROR: $err`n"
}

function showMessage($msg) {
  write-host -ForegroundColor green "`n$msg`n"
}

# Can receive one parameter with the docker registry to log in to.
function dockerLogin($server) {
  write-host "Docker Credentials:"
  $usernameDocker = read-host -Prompt "Login"
  $securePassword = read-host -Prompt "Password" -AsSecureString
  $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
  $unsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
  $ErrorActionPreference = "stop"
  try 
  {
    if ($server) 
    {
      docker login -u $usernameDocker -p $unsecurePassword $server 2>$null
    }
    else
    {
      docker login -u $usernameDocker -p $unsecurePassword 2>$null
      
    }
  }
  catch 
  {
    if ($LastExitCode -ne 0) 
    {
      write-host -F Red "Login Failed"
    }
    $errormessage = $_.TargetObject
    write-host -F Yellow $errormessage
  }
}

<#



function verifyVPC() {
    cat /ICM/etc/Terraform/GCP/VPC/infrastructure.tf | grep jupyter
    if [ $? -eq 1 ]
    then
        prinfY "\n\nAdding Additional Firewall Rules to ICM for GCP...\n\n" 
        cat /irisdemo/templates/GCP/infrastructure.tf >> /ICM/etc/Terraform/GCP/VPC/infrastructure.tf
    fi
}


#>


function funcTest([string]$param1,[string]$param2)
{
  write-host "To execute.... Param1: `$param1 / Param2: `$param2"
  write-host "this is a test. Param1: $param1 / Param2: $param2"
  return 1
}
