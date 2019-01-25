# We need files from this previous version. 
# They were deleted on 2018.2 and were neessary for iKnow Portals to work
FROM amirsamary/irisdemo:iris.2018.1.1-stable

FROM amirsamary/irisdemo:irishealth.2019.1.0-stable
LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# Copy deleted files from 2018.1.1 into 2018.2:
COPY --from=0 --chown=root:irisusr /usr/irissys/csp/broker/jquery-2.0.3.min.js /usr/irissys/csp/broker
COPY --from=0 --chown=root:irisusr /usr/irissys/csp/broker/bootstrap-3-3-5/ /usr/irissys/csp/broker/bootstrap-3-3-5/

# Name of the project folder ex.: irisdemodb-atelier-project
ARG IRIS_PROJECT_FOLDER_NAME

# Used to specify a folder on the container with the source code (csp pages, classes, etc.)
# to load into the CSP application.
ENV IRIS_APP_SOURCEDIR=/tmp/iris_project/

# Name of the application. This will be used to define the namespace, database and 
# name of the CSP application of this application.
ENV IRIS_APP_NAME="APP"

# Used by runinstaller.sh to load the installer manifest class and run it
ENV IRIS_USERNAME="SuperUser" 

# Used by runinstaller.sh and to set instance's default password (this is just a demo!)
ENV IRIS_PASSWORD="sys"

# This is an image for using with demos. I don't care about protecting the password. I just
# want all instances to have the same password.
RUN echo "$IRIS_PASSWORD" >> /tmp/pwd.isc && /usr/irissys/dev/Cloud/ICM/changePassword.sh /tmp/pwd.isc

# IRIS Global buffers and Routine Buffers
ENV IRIS_GLOBAL_BUFFERS=128
ENV IRIS_ROUTINE_BUFFERS=64

# Adding source code that will be loaded by the installer
ADD ./${IRIS_PROJECT_FOLDER_NAME}/ $IRIS_APP_SOURCEDIR

# Loading the base installer.
ADD ./irisdemobaseinstaller.sh /usr/irissys/demo/irisdemobaseinstaller.sh
RUN /usr/irissys/demo/irisdemobaseinstaller.sh

# Running the base installer
ADD ./irisdemoinstaller.sh /usr/irissys/demo/irisdemoinstaller.sh
RUN /usr/irissys/demo/irisdemoinstaller.sh