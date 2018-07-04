FROM amirsamary/irisdemo:iris.2018.2.0-stable
LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# This is an image for using with demos. I don't care about protecting the password
#
RUN echo 'sys' >> /tmp/pwd.isc && /usr/irissys/dev/Cloud/ICM/changePassword.sh /tmp/pwd.isc; if [ $? -eq 5 ]; then exit 0; else exit $?; fi

