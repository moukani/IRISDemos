FROM amirsamary/irisdemo:irisdemodb
FROM amirsamary/irisdemo:irishibernate

# Here is our real image. This is the universe we are going to stay on. 
# https://hub.docker.com/r/jboss/wildfly/
FROM jboss/wildfly:15.0.0.Final
LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# This script allow us to do additional configuration work before starting JBoss
ADD --chown=jboss:root ./buildfiles/startservices.sh /custom/
ADD --chown=jboss:root ./buildfiles/configure-jboss.* /custom/

# Configuring IRIS JDBC Driver module
ADD --chown=jboss:root ./buildfiles/iris-jdbc-module.xml $JBOSS_HOME/modules/com/intersystems/main/module.xml
COPY --from=0 --chown=jboss:root  /usr/irissys/dev/java/lib/JDK18/*.jar $JBOSS_HOME/modules/com/intersystems/main/

# Adding the InterSystems IRIS Hibernate Dialect we build on the other image
# That will be like this until ticket https://hibernate.atlassian.net/browse/HHH-12597 incorporates
# this on JBoss for us. Vote for us there!!!
COPY --from=1 --chown=jboss:root  /tmp/hibernate/HibernateInterSystemsIRISDialect.jar $JBOSS_HOME/modules/system/layers/base/org/hibernate/main

# Configuring IRIS JDBC Driver and IRIS Hibernate Dialect
RUN /custom/configure-jboss.sh
# Good reference documentation: https://docs.jboss.org/author/display/AS71/CLI+Recipes#CLIRecipes-AddaNewJDBCDriver
# RUN $JBOSS_HOME/bin/standalone.sh & \
#     $JBOSS_HOME/bin/jboss-cli.sh --connect controller=localhost --commands=/subsystem=datasources/jdbc-driver=com.intersystems.jdbc.IRISDriver:add(driver-name=com.intersystems.jdbc.IRISDriver,driver-datasource-class-name=com.intersystems.jdbc.IRISDataSource,driver-module-name=com.intersystems)

# Uncomment when we have a war to add
# ADD app.war /opt/jboss/wildfly/standalone/deployments/ 

CMD [ "/custom/startservices.sh" ]

