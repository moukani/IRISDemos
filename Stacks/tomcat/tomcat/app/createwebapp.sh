#!/bin/bash
#
# Based on https://maven.apache.org/archetypes/maven-archetype-webapp/
#

mvn archetype:generate -DarchetypeGroupId=org.apache.maven.archetypes -DarchetypeArtifactId=maven-archetype-webapp -DarchetypeVersion=1.3

# this is required so we can deploy our jar file to Tomcat using maven
if [ ! -d ~/.m2 ]
then
    mkdir ~/.m2
fi
cp -f ./maven_settings.xml ~/.m2/settings.xml
