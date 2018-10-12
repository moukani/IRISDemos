FROM amirsamary/irisdemo:irisdemodb
LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# Name of the project folder ex.: my-atelier-project
ARG IRIS_PROJECT_FOLDER_NAME

# Adding source code that will be loaded by the installer
ADD ./${IRIS_PROJECT_FOLDER_NAME}/ $IRIS_APP_SOURCEDIR

# This file will be loaded into the APP namespace and deleted by the IRISConfig.Installer
# I downloaded this file from Kaggle (https://www.kaggle.com/ntnu-testimon/banksim1)
# I opened it to convert it from CR/LF to LF and compressed it into a tar.gz file
ADD ./banksim_data.tar.gz /tmp/

# IRIS Global buffers and Routine Buffers
# ENV IRIS_GLOBAL_BUFFERS=256
# ENV IRIS_ROUTINE_BUFFERS=64

# Running the installer. This will load the source from our project.
RUN /usr/irissys/demo/irisdemoinstaller.sh