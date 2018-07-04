# https://hub.docker.com/_/tomcat/
# https://docs.docker.com/samples/library/tomcat/
# http://trimc-devops.blogspot.com/2015/03/running-docker-applications-apache.html

FROM tomcat:8.0
LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

ADD ./image_build_files/lib/*.jar /custom/lib/

ENV CLASSPATH "/custom/lib/intersystems-jdbc-3.0.0.jar:/custom/lib/intersystems-utils-3.0.0.jar:/usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar"