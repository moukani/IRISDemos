#!/bin/bash
#
# Amir Samary - 2018
#

# This script expects to receive as environment variables:
# - IRIS_MASTER_HOST        : This will set a default configuration for where the IRIS server is so that 
#                             our JDBC driver running on JBOSS can connect to it. 
# - IRIS_MASTER_PORT        : The same as above for the iris port. This should be the super server port.
# - IRIS_MASTER_USERNAME    : The same as above for the iris username.
# - IRIS_MASTER_PASSWORD    : The same as above for the iris password.
# - IRIS_MASTER_NAMESPACE   : The same as above for the iris namespace.

# Creating the admin user to enter the management portal:
$JBOSS_HOME/bin/add-user.sh admin Admin#1234 --silent

for variable in IRIS_MASTER_HOST IRIS_MASTER_PORT IRIS_MASTER_NAMESPACE IRIS_MASTER_USERNAME IRIS_MASTER_PASSWORD;
do
    value=$(eval echo "\$$variable")
    if [ ! -z "$value" ]
    then
        printf "\n\nConfiguring $JBOSS_HOME/standalone/configuration/standalone.xml with $variable=$value..."
        sed -i.bak "s/$variable/$value/g" $JBOSS_HOME/standalone/configuration/standalone.xml
    fi
done

printf "\n\n"

# Changing the original CMD to enable the management portal
$JBOSS_HOME/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0