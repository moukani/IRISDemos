# Multi-build Dockerfile. This image will not be included into our final image. 
# We just need a reference to it. I will use that to extract IRIS jar files and JPMML Jars from it.
# Think of it as a parallel universe we just entered and it is called now "universe 0".
FROM amirsamary/irisdemo:spark-iris

# Here is our real image. This is the universe we are going to stay on. 
FROM apache/zeppelin:0.7.3
LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# IRIS Jars, JPMML Jars, etc.
COPY --from=0 /custom/ /custom/

# Zeppelin will be started on port:
EXPOSE 9090

# Zeppelin configurations:
ENV ZEPPELIN_NOTEBOOK_DIR /shared/zeppelin/notebook
ENV ZEPPELIN_CONF_DIR /shared/zeppelin/conf
ENV ZEPPELIN_LOG_DIR /shared/zeppelin/logs

RUN pip install --upgrade pip && \
    pip install pandas && \
    pip install seaborn && \
    pip install sklearn

# These configuration files have variables that need to be replaced before zeppelin or spark
# start. This substituion is done by /custom/bin/startservices.sh custom script that I
# built. 

# I added a new interpreter to the file, called irisjdbc. This interpreter allows us to 
# easily run SQL through JDBC on IRIS out of the box. It needs:
# - IRIS_MASTER_HOST        : This will set a default configuration for where the IRIS server is so that 
#                             our jdbc driver can connect to it. 
# - IRIS_MASTER_PORT        : The same as above for the iris port. This should be the super server port.
# - IRIS_MASTER_USERNAME    : The same as above for the iris username.
# - IRIS_MASTER_PASSWORD    : The same as above for the iris password.
# - IRIS_MASTER_NAMESPACE   : The same as above for the iris namespace.
ADD ./image_build_files/zeppelin/conf/interpreter.json /zeppelin/conf/

# This file has nothing to be replaced. It only has only configured zeppelin.server.port=9090.
# This port used to be 8080 and this would collide with the Spark Master Portal port.
ADD ./image_build_files/zeppelin/conf/zeppelin-site.xml /zeppelin/conf/

# HADOOP
ENV HADOOP_VERSION 2.7.7
ENV HADOOP_HOME /usr/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin
COPY --from=0 $HADOOP_HOME/ $HADOOP_HOME/
RUN chown -R root:root $HADOOP_HOME

# SPARK
ENV SPARK_VERSION 2.1.3
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-without-hadoop
ENV SPARK_HOME /usr/spark-${SPARK_VERSION}
ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"
ENV PATH $PATH:${SPARK_HOME}/bin
ENV SPARK_OPTS --driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info
COPY --from=0 $SPARK_HOME/ $SPARK_HOME/
RUN chown -R root:root $SPARK_HOME

ADD ./image_build_files/sbin/startservices.sh /custom/sbin/
RUN chmod +x /custom/sbin/startservices.sh
   
WORKDIR ${Z_HOME}

ENTRYPOINT [ "/usr/bin/tini", "-s", "--", "/custom/sbin/startservices.sh" ]
