FROM amirsamary/irisdemo:irisdemoint
LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# Name of the project folder ex.: my-atelier-project
ARG IRIS_PROJECT_FOLDER_NAME

# Adding source code that will be loaded by the installer
ADD ./${IRIS_PROJECT_FOLDER_NAME}/ $IRIS_APP_SOURCEDIR

ADD https://github.com/intersystems-ru/EnsembleWorkflow/releases/download/v1.0/Workflow.xml /tmp/installers/Workflow.xml

# This folder will be shared with the other containers (i.e.: archivedb)
RUN mkdir /common_shared/ && \
    mkdir /common_shared/transformer_signals/ && \
    mkdir /common_shared/pmml && \
    chgrp irisusr -R /common_shared && \
    chmod g+w -R /common_shared/

# Running the installer. This will load the source from our project.
RUN /usr/irissys/demo/irisdemoinstaller.sh

ADD ./html/pmml.xml $ISC_PACKAGE_INSTALLDIR/csp/appint/
ADD ./html/IoTPredMaintenance.png $ISC_PACKAGE_INSTALLDIR/csp/appint/
ADD ./html/image-map-resizer/js/imageMapResizer.min.js $ISC_PACKAGE_INSTALLDIR/csp/appint/
ADD ./html/image-map-resizer/js/imageMapResizer.map $ISC_PACKAGE_INSTALLDIR/csp/appint/