#!/bin/bash
#
# Amir Samary - 2018
#
# All this script does is to run the Installer Manifest on class IRISConfig.Installer.
# The class will be run on %SYS namespace as it should be. The user name and password used to load
# the installer class and run it must be specified on environment variables
# IRIS_USERNAME and IRIS_PASSWORD.

# This must not be used on production. This is a work around to have journaling working when
# working on Mac
printf "\nAdding configuration to iris.cpf so that Journaling will be enabled when running on non-linux platform (Mac)..."
cat /usr/irissys/iris.cpf | grep usedirectio
if [ $? -eq 1 ]
then
    printf "\n\tAdding ausedirectio=-1 to iris.cpf...\n"
    sed -i '/\[config\]/ausedirectio=-1' /usr/irissys/iris.cpf
else
    printf "\n\tausedirectio=-1 is already there.\n"
fi

# From now on, any error should interrupt the script
set -e

printf "\nRunning installer...\n"

iris start iris

VerifySC='If $System.Status.IsError(tSC) { Do $System.Status.DisplayError(tSC) Do $zu(4,$j,1) } Else { Do $zu(4,$j,0) }'

printf "\n\nLoading Installer..."

# This specific command may fail on images that are based on this because I don't expect to find IRISDemo.InstallerBase 
# on the developer's project (they should not override this class on their projects!)
# That is why we are not checking the status code.
printf "%s\n%s\nzn \"%s\"\nSet tSC=\$system.OBJ.Load(\"%s\",\"ck\")\n" "$IRIS_USERNAME" "$IRIS_PASSWORD" "%SYS" "/tmp/iris_project/IRISConfig/InstallerBase.cls" | irissession IRIS

# This, on the other hand, should never fail and as it depends on the existence of the previous class
# it may fail if it hasn't been loaded correctly. 
printf "%s\n%s\nzn \"%s\"\nSet tSC=\$system.OBJ.Load(\"%s\",\"ck\")\n$VerifySC\n" "$IRIS_USERNAME" "$IRIS_PASSWORD" "%SYS" "/tmp/iris_project/IRISConfig/Installer.cls" | irissession IRIS

printf "\n\nRunning Installer..."
printf "%s\n%s\n%s\n%s\n" "$IRIS_USERNAME" "$IRIS_PASSWORD" "zn \"%SYS\"" "Do ##class(IRISConfig.Installer).Install()" | irissession IRIS

printf "\n\nCleanning up..."
printf "%s\n%s\n%s\n%s\n%s\n%s\n" "$IRIS_USERNAME" "$IRIS_PASSWORD" "zn \"%SYS\"" "do INT^JRNSTOP" "kill ^%SYS(\"Journal\")" "Halt" | irissession IRIS

iris stop iris quietly

rm $ISC_PACKAGE_INSTALLDIR/mgr/IRIS.WIJ
rm -f $ISC_PACKAGE_INSTALLDIR/mgr/iris.ids
rm $ISC_PACKAGE_INSTALLDIR/mgr/journal/*

rm -rf /tmp/iris_project