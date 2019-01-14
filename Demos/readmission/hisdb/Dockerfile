FROM amirsamary/irisdemo:readmission_RRLACESrv

FROM amirsamary/irisdemo:irishealthdemoint
LABEL maintainer="Phillip Booth <phillip.booth@intersystems.com>"

COPY --from=0 /tmp/export_to_hisdb.csv /tmp/

# Name of the project folder ex.: my-atelier-project
ARG IRIS_PROJECT_FOLDER_NAME

# Adding source code that will be loaded by the installer
ADD ./${IRIS_PROJECT_FOLDER_NAME}/ $IRIS_APP_SOURCEDIR

# Running the installer. This will load the source from our project.
RUN /usr/irissys/demo/irisdemoinstaller.sh && \
    rm -f /tmp/export_to_hisdb.csv
