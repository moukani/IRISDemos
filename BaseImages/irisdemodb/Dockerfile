FROM amirsamary/irisdemo:iris.2018.2.0-stable
LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# Name of the project folder ex.: irisdemodb-atelier-project
ARG IRIS_PROJECT_FOLDER_NAME

# Name of the application. This will be used to define the namespace, database and 
# name of the CSP application of this application.
ENV IRIS_APP_NAME="APP"

# Used by runinstaller.sh to load the installer manifest class and run it
ENV IRIS_USERNAME="SuperUser" 

# Used by runinstaller.sh and to set instance's default password (this is just a demo!)
ENV IRIS_PASSWORD="sys"

# Installer Manifest to deploy the app
ENV IRIS_INSTALLER_CLASSNAME="IRISDemo.SYS.Installer"

# Used to specify a folder on the container with the source code (csp pages, classes, etc.)
# to load into the CSP application.
ENV IRIS_APP_SOURCEDIR=/tmp/${IRIS_PROJECT_FOLDER_NAME}

# This is an image for using with demos. I don't care about protecting the password
#
RUN echo "$IRIS_PASSWORD" >> /tmp/pwd.isc && /usr/irissys/dev/Cloud/ICM/changePassword.sh /tmp/pwd.isc; if [ $? -eq 5 ]; then exit 0; else exit $?; fi

# Adding the installer
ADD ./${IRIS_PROJECT_FOLDER_NAME}/IRISDemo/SYS/Installer.cls /tmp/appinstaller.cls

# Adding source code that will be loaded by the installer
ADD ./${IRIS_PROJECT_FOLDER_NAME}/ /tmp/${IRIS_PROJECT_FOLDER_NAME}/

# Running the installer.
ADD ./runinstaller.sh /tmp/runinstaller.sh
RUN /tmp/runinstaller.sh

# Cleaning up
RUN rm -rf /tmp/${IRIS_PROJECT_FOLDER_NAME} && rm /tmp/appinstaller.cls