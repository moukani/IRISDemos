FROM amirsamary/irisdemo:irisdemodb
LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# Name of the project folder ex.: my-atelier-project
ARG IRIS_PROJECT_FOLDER_NAME

# Adding source code that will be loaded by the installer
ADD ./${IRIS_PROJECT_FOLDER_NAME}/ $IRIS_APP_SOURCEDIR

# This file will be loaded into the APP namespace and deleted by the IRISConfig.Installer
# I downloaded this file from Kaggle (https://www.kaggle.com/ntnu-testimon/banksim1)
# I opened it to convert it from CR/LF to LF and compressed it into a tar.gz file
# ADD ./banksim_data.tar.gz /tmp/

# Our project includes an IRIS NLP Domain Class. In order to compile this class, IRIS needs
# a license with NLP/iKnow enabled. So we are temporarily adding the license to the image. 
# We will remove it after we are done (after running irisdemoinstaller.sh)
# But we should find another way of doing this because now the iris.key license will be in the
# layers of this image and could be retrived by someone.
ADD ./iris.key /usr/irissys/mgr/

# Running the installer. This will load the source from our project, compile it and then remove the iris.key
RUN /usr/irissys/demo/irisdemoinstaller.sh