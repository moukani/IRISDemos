# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# Spark configurations taken from Jupyter notebook on:
# https://github.com/jupyter/docker-stacks/blob/master/pyspark-notebook/Dockerfile
#

#
# Use script run.sh to run this image. You can ask for its help with:
#
# ./run.sh -h
#

# Multi-build Dockerfile. This image will not be included into our final image. 
# We just need a reference to it. I will use that to extract IRIS jar files from it.
# Think of it as a parallel universe we just entered and it is called now "universe 0".
FROM amirsamary/irisdemo:irisdemodb

# Here is our real image. This is the universe we are going to stay on. 
FROM apache/zeppelin:0.7.3
LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# Now we can extract those jar files from universe 0, and bring them into our universe... ;)
COPY --from=0 /usr/irissys/dev/java/lib/JDK18/*.jar /custom/lib/

# Zeppelin will be started on port:
EXPOSE 9090

# Spark Master will be started on its default port 8080
EXPOSE 8080

# Spark Slave will be started on its default port 8081
EXPOSE 9092

# Zeppelin configurations:
ENV ZEPPELIN_NOTEBOOK_DIR /shared/zeppelin/notebook
ENV ZEPPELIN_CONF_DIR /shared/zeppelin/conf
ENV ZEPPELIN_LOG_DIR /shared/zeppelin/logs

# Spark dependencies
ENV APACHE_SPARK_VERSION 2.1.3
ENV HADOOP_VERSION 2.7

# In the future, we may expose 7077 so we can let outside workers to join the 
# spark master we are starting inside this container. What I really want though, is
# to refactor this image into two: One for Zeppelin and another for Spark (with our
# stuff in it). But for now, I will cook Spark into the Zeppelin image and keep
# the number of images and containers small. The following environment variable
# will be used by startservices.sh to replace it on spark-defaults.conf
ENV SPARK_MASTER_PORT 7077
ENV SPARK_LOG_DIR /shared/spark/logs
ENV SPARK_CONF_DIR /shared/spark/conf

# The startservices.sh script will copy spark and zeppelin configuration folders into
# their respective folders inside the /shared folder and replace variables into these files
# to reflect the configurations we want. It will also set up other folders such as 
# the notebook folder, log folders, etc. under /shared so we can easily map them to 
# folders on our host when starting the container with -v options.

ENV SPARK_HOME /usr/local/spark

# Setting SPARK_CONF_DIR here makes it also available when we run the container
# interactively with 'docker run -it ...'. That will make spark CLI utilities such as
# pyspark use our configuration on /shared/spark/conf instead of the default configuration
# brought with spark. 
ENV SPARK_CONF_DIR /shared/spark/conf

ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.7-src.zip
ENV SPARK_OPTS --driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y openjdk-8-jre-headless ca-certificates-java && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
        wget -q http://apache.claz.org/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
        tar xzf spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /usr/local --owner root --group root --no-same-owner && \
        rm spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
RUN cd /usr/local && ln -s spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark

RUN cd /custom/lib && \
    wget -q https://github.com/jpmml/jpmml-sparkml/releases/download/1.2.12/jpmml-sparkml-executable-1.2.12.jar

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

# This file has many strings to be replaced:
# - SPARK_MASTER_HOST       : This is used by spark CLI such as pyspark to determine where spark master is.
# - SPARK_MASTER_PORT       : The same as above for the spark master port.
# - IRIS_MASTER_HOST        : This will set a default configuration for where the IRIS server is so that 
#                             our spark connector can connect to it. This can be replaced when creating a
#                             spark session. But having a default makes creating the session more straightforward.
# - IRIS_MASTER_PORT        : The same as above for the iris port. This should be the super server port.
# - IRIS_MASTER_USERNAME    : The same as above for the iris username.
# - IRIS_MASTER_PASSWORD    : The same as above for the iris password.
# - IRIS_MASTER_NAMESPACE   : The same as above for the iris namespace.
ADD ./image_build_files/spark/conf/spark-defaults.conf $SPARK_HOME/conf/

ADD ./image_build_files/sbin/startservices.sh /custom/sbin/
RUN chmod +x /custom/sbin/startservices.sh

ENV PATH "${SPARK_HOME}/bin:${PATH}"

WORKDIR ${Z_HOME}

ENTRYPOINT [ "/usr/bin/tini", "-s", "--", "/custom/sbin/startservices.sh" ]
