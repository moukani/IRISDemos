#!/bin/bash
#
# Amir Samary - 2018
#
# All this script does is to run the Installer Manifest on class IRISConfig.Installer.
# The class will be run on %SYS namespace as it should be. The user name and password used to load
# the installer class and run it must be specified on environment variables
# IRIS_USERNAME and IRIS_PASSWORD.

set -e

printf "\nRunning installer...\n"

iris start iris

VerifySC='If $System.Status.IsError(tSC) { Do $System.Status.DisplayError(tSC) Do $zu(4,$j,1) } Else { Do $zu(4,$j,0) }'

printf "\n\nLoading /tmp/appinstaller.cls..."
printf "%s\n%s\nzn \"%s\"\nSet tSC=\$system.OBJ.Load(\"%s\",\"ck\")\n$VerifySC\n" "$IRIS_USERNAME" "$IRIS_PASSWORD" "%SYS" "/tmp/iris_project/IRISConfig/Installer.cls" | irissession IRIS

printf "\n\nRunning /tmp/appinstaller.cls..."
printf "%s\n%s\n%s\n%s\n" "$IRIS_USERNAME" "$IRIS_PASSWORD" "zn \"%SYS\"" "Do ##class(IRISConfig.Installer).Install()" | irissession IRIS

printf "\n\nCleanning up..."
printf "%s\n%s\n%s\n%s\n%s\n%s\n" "$IRIS_USERNAME" "$IRIS_PASSWORD" "zn \"%SYS\"" "do INT^JRNSTOP" "kill ^%SYS(\"Journal\")" "Halt" | irissession IRIS

iris stop iris quietly

rm $ISC_PACKAGE_INSTALLDIR/mgr/IRIS.WIJ

rm $ISC_PACKAGE_INSTALLDIR/mgr/journal/*

rm -rf /tmp/iris_project