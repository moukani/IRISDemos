FROM mobilebanking_datalake:latest


FROM amirsamary/irisdemo:irisdemoint
LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# Let's copy the exported file whitelist.csv from the datalake image into our image
COPY --from=0 /tmp/whitelist.csv /tmp/

# Name of the project folder ex.: my-atelier-project
ARG IRIS_PROJECT_FOLDER_NAME

# Adding source code that will be loaded by the installer
ADD ./${IRIS_PROJECT_FOLDER_NAME}/ $IRIS_APP_SOURCEDIR

# Running the installer. This will load the source from our project.
RUN /usr/irissys/demo/irisdemoinstaller.sh