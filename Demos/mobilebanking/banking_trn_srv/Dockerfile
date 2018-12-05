FROM amirsamary/irisdemo:mobilebanking_datalake

FROM amirsamary/irisdemo:irisdemoint
LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# Let's copy the exported file whitelist.csv from the datalake image into our image
COPY --from=0 /tmp/whitelist.csv /tmp/

# This folder will be shared with the other containers (i.e.: normalized_datalake)
RUN mkdir /common_shared/ && \
    mkdir /common_shared/pmml && \
    mkdir /common_shared/pmml/imported && \
    chgrp irisusr -R /common_shared && \
    chmod g+w -R /common_shared/

# Name of the project folder ex.: my-atelier-project
ARG IRIS_PROJECT_FOLDER_NAME

# Adding source code that will be loaded by the installer
ADD ./${IRIS_PROJECT_FOLDER_NAME}/ $IRIS_APP_SOURCEDIR

# Running the installer. This will load the source from our project.
RUN /usr/irissys/demo/irisdemoinstaller.sh

ADD ./html/pmml.xml $ISC_PACKAGE_INSTALLDIR/csp/appint/
ADD ./html/PaymentDemo.png $ISC_PACKAGE_INSTALLDIR/csp/appint/
ADD ./html/image-map-resizer/js/imageMapResizer.min.js $ISC_PACKAGE_INSTALLDIR/csp/appint/
ADD ./html/image-map-resizer/js/imageMapResizer.map $ISC_PACKAGE_INSTALLDIR/csp/appint/