FROM amirsamary/irisdemo:iris.2018.2.0-stable
LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# Install Java.
RUN \
  apt-get update && \
  apt-get install -y software-properties-common && \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Name of the project folder ex.: irisdemodb-atelier-project
ARG IRIS_PROJECT_FOLDER_NAME

# Used to specify a folder on the container with the source code (csp pages, classes, etc.)
# to load into the CSP application.
ENV IRIS_APP_SOURCEDIR=/tmp/iris_project/

# Name of the application. This will be used to define the namespace, database and 
# name of the CSP application of this application.
ENV IRIS_APP_NAME="APPINT"

# Used by runinstaller.sh to load the installer manifest class and run it
ENV IRIS_USERNAME="SuperUser" 

# Used by runinstaller.sh and to set instance's default password (this is just a demo!)
ENV IRIS_PASSWORD="sys"

# This is an image for using with demos. I don't care about protecting the password
#
RUN echo "$IRIS_PASSWORD" >> /tmp/pwd.isc && /usr/irissys/dev/Cloud/ICM/changePassword.sh /tmp/pwd.isc; if [ $? -eq 5 ]; then exit 0; else exit $?; fi

# IRIS Global buffers and Routine Buffers
ENV IRIS_GLOBAL_BUFFERS=128
ENV IRIS_ROUTINE_BUFFERS=64

# Adding source code that will be loaded by the installer
ADD ./${IRIS_PROJECT_FOLDER_NAME}/ $IRIS_APP_SOURCEDIR

# Adding PMML.xml to fix a problem with our PMML parser
ADD ./PMML.xml /tmp/PMML.xml

# Running the installer.
ADD ./irisdemoinstaller.sh /usr/irissys/demo/irisdemoinstaller.sh
RUN /usr/irissys/demo/irisdemoinstaller.sh