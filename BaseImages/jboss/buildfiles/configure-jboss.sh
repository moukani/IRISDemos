#!/bin/bash
# Author: Amir Samary
# Taken and adapted from https://goldmann.pl/blog/2014/07/23/customizing-the-configuration-of-the-wildfly-docker-image/
#
# Validate if we should use IRISDataSource instead of IRISDriver. Removed command:
# /subsystem=datasources/jdbc-driver=com.intersystems.jdbc.IRISDriver:add(driver-name=com.intersystems.jdbc.IRISDriver,driver-datasource-class-name=com.intersystems.jdbc.IRISDataSource,driver-module-name=com.intersystems)
# from configure-jboss.cli.
#
JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh
JBOSS_MODE=${1:-"standalone"}
JBOSS_CONFIG=${2:-"$JBOSS_MODE.xml"}

function wait_for_server() {
  until `$JBOSS_CLI -c "ls /deployment" &> /dev/null`; do
    sleep 1
  done
}

echo "=> Starting WildFly server"
$JBOSS_HOME/bin/$JBOSS_MODE.sh -c $JBOSS_CONFIG > /dev/null &

echo "=> Waiting for the server to boot"
wait_for_server

echo "=> Executing the commands"
$JBOSS_CLI -c --file=/custom/configure-jboss.cli

echo "=> Shutting down WildFly"
if [ "$JBOSS_MODE" = "standalone" ]; then
  $JBOSS_CLI -c ":shutdown"
else
  $JBOSS_CLI -c "/host=*:shutdown"
fi

# Cleaning up
rm -rf $JBOSS_HOME/standalone/configuration/standalone_xml_history/current