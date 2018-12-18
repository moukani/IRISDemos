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

# From now on, any error should interrupt the script
set -e

printf "\n Configuring global buffers..."
sed -i "s/globals=.*/globals=0,0,$IRIS_GLOBAL_BUFFERS,0,0,0/" /usr/irissys/iris.cpf

printf "\n Configuring routine buffers..."
sed -i "s/routines=.*/routines=$IRIS_ROUTINE_BUFFERS/" /usr/irissys/iris.cpf

iris start iris

VerifySC='If $System.Status.IsError(tSC) { Do $System.Status.DisplayError(tSC) Do $zu(4,$j,1) } Else { Do $zu(4,$j,0) }'

printf "\n\nLoading Installer..."

# This, on the other hand, should never fail and as it depends on the existence of the previous class
# it may fail if it hasn't been loaded correctly. 
printf "%s\n%s\nzn \"%s\"\nSet tSC=\$system.OBJ.Load(\"%s\",\"ck\")\n$VerifySC\n" "$IRIS_USERNAME" "$IRIS_PASSWORD" "%SYS" "/tmp/iris_project/IRISConfig/Installer.cls" | irissession IRIS

# Removing Eclipse/Atelier files so that when we try to load our project we don't get the
# following error:
# ERROR #5840: Unable to import file '/tmp/iris_project/.buildpath' as this is not a supported type.ERROR: Service 'twittersrv' failed to build: The command '/bin/sh -c /usr/irissys/demo/irisdemoinstaller.sh' returned a non-zero code: 1
rm -f /tmp/iris_project/.buildpath
rm -f /tmp/iris_project/.project
rm -f /tmp/iris_project/.settings

# Running the installer...
printf "\n\nRunning Installer..."
printf "%s\n%s\n%s\n%s\n" "$IRIS_USERNAME" "$IRIS_PASSWORD" "zn \"%SYS\"" "Do ##class(IRISConfig.Installer).Install()" | irissession IRIS

printf "\n\nCleaning up..."
printf "%s\n%s\n%s\n%s\n%s\n%s\n" "$IRIS_USERNAME" "$IRIS_PASSWORD" "zn \"%SYS\"" "do INT^JRNSTOP" "kill ^%SYS(\"Journal\")" "Halt" | irissession IRIS

iris stop iris quietly

rm -f $ISC_PACKAGE_INSTALLDIR/mgr/IRIS.WIJ
rm -f $ISC_PACKAGE_INSTALLDIR/mgr/iris.ids
rm -f $ISC_PACKAGE_INSTALLDIR/mgr/alerts.log
rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal/*
rm -f $ISC_PACKAGE_INSTALLDIR/mgr/messages.log

rm -rf /tmp/iris_project