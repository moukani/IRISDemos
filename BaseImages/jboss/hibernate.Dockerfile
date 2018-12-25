FROM amirsamary/irisdemo:irisdemodb

# This dockerfile is used to build the jar for InterSystems 
# IRIS Hibernate dialect and nothing else. It will be referenced by the 
# main Dockerfile on this folder. By doing it this way, we can take advantage of the same
# java compiler that jboss is using as well as all other libraries it has.
# I am using JDK 8 because if I try to build it using newer JDK11, I will get
# the error java.lang.ClassNotFoundException: javax.xml.bind.JAXBException. This class
# has been removed from JDK11 because it is only available now on Java EE. JBoss 10 with JDK 11 will
# have it at runtime, but to compile our code in a simpler way, I decided to do it with JDK 8.
#
# The jar will be available, inside the image on /tmp/hibernate/HibernateInterSystemsIRISDialect.jar
#
FROM jboss/base-jdk:8
LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# We will need IRIS jar files
COPY --from=0 --chown=jboss:root  /usr/irissys/dev/java/lib/JDK18/*.jar /tmp/irislib/

# Adding Hibernate support until ticket https://hibernate.atlassian.net/browse/HHH-12597 incorporates
# this on JBoss. InterSystems has published this project on their github and until an official
# version of the dialect comes out, we will use this one. InterSystems has already prepared the lib
# folder for us with all the dependencies we need!
ADD --chown=jboss:root ./buildfiles/quickstarts-java/ /tmp/hibernate/

WORKDIR /tmp/hibernate/src

RUN rm -rf ./Solutions && \
    find -name "*.java" > sources.txt && \
    cat ./sources.txt && \
    javac -cp "../lib/*:/tmp/irislib/*" @sources.txt && \
    find -name "*.class" > classes.txt && \
    jar cf /tmp/hibernate/HibernateInterSystemsIRISDialect.jar @classes.txt
