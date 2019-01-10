FROM amirsamary/irisdemo:irishealthdemoint
LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# Name of the project folder ex.: my-atelier-project
ARG IRIS_PROJECT_FOLDER_NAME

# Adding source code that will be loaded by the installer
ADD ./${IRIS_PROJECT_FOLDER_NAME}/ $IRIS_APP_SOURCEDIR

# This file will be loaded into the APP namespace and deleted by the IRISConfig.Installer
# These are the clinical data files for comorbidity indices, clinical data and SNOMED->ICD mapping
# ADD ./banksim_data.tar.gz /tmp/
# ADD ./ComorbidityIndexMapping.csv /tmp/
# ADD ./patient_demographics.csv /tmp/
ADD ./RRLACESrv.tar.gz /tmp/

# Running the installer. This will load the source from our project.
RUN /usr/irissys/demo/irisdemoinstaller.sh && \
    rm /tmp/ComorbidityIndexMapping.csv && \
    rm /tmp/patient_demographics.csv && \
    rm /tmp/patient_encounters.csv && \
    rm /tmp/patient_diagnoses.csv