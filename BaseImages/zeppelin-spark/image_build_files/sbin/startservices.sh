#!/bin/bash
#
# Amir Samary - 2018
#

# This script expects to receive as environment variables:
# - IRIS_MASTER_HOST        : This will set a default configuration for where the IRIS server is so that 
#                             our spark connector can connect to it. This can be replaced when creating a
#                             spark session. But having a default makes creating the session more straightforward.
# - IRIS_MASTER_PORT        : The same as above for the iris port. This should be the super server port.
# - IRIS_MASTER_USERNAME    : The same as above for the iris username.
# - IRIS_MASTER_PASSWORD    : The same as above for the iris password.
# - IRIS_MASTER_NAMESPACE   : The same as above for the iris namespace.

# Spark configurations:
hostname=$(hostname -f)
if [ ! $? == 0 ] 
then
    hostname="localhost"
    printf "\n\nCould not determine FQDN. Using '$hostname'.\n\n"
fi

# Quit on any error
set -e

export SPARK_MASTER_HOST=$hostname

if [ ! -d /tmp/spark-events ]
then
    mkdir /tmp/spark-events
fi

if [ ! -d /shared/zeppelin ]
then
    mkdir /shared/zeppelin    
fi

if [ ! -d /shared/zeppelin/notebook ]
then
    mkdir /shared/zeppelin/notebook    
fi

if [ ! -d /shared/zeppelin/conf ]
then
    cp -R /zeppelin/conf /shared/zeppelin/
fi

if [ ! -d /shared/spark ]
then
    mkdir /shared/spark    
fi

if [ ! -d /shared/spark/conf ]
then
    mkdir /shared/spark/conf
    cp /usr/local/spark/conf/log4j.properties.template /shared/spark/conf/log4j.properties
    cp /usr/local/spark/conf/spark-defaults.conf /shared/spark/conf/
    #cp /usr/local/spark/conf/spark-env.sh.template /shared/spark/conf/spark-env.sh
fi

for variable in SPARK_MASTER_HOST SPARK_MASTER_PORT IRIS_MASTER_HOST IRIS_MASTER_PORT IRIS_MASTER_NAMESPACE IRIS_MASTER_USERNAME IRIS_MASTER_PASSWORD;
do
    value=$(eval echo "\$$variable")
    sed -i.bak "s/$variable/$value/g" /shared/zeppelin/conf/interpreter.json
    sed -i.bak "s/$variable/$value/g" /shared/spark/conf/spark-defaults.conf
done

chmod g+r,o+r /shared/zeppelin/conf/interpreter.json
chmod g+r,o+r /shared/spark/conf/spark-defaults.conf

#sleep 120

# Amir Samary
# 
# There are two ways of starting spark workers that I could find:
# - By calling start-all.sh or start-slaves.sh: These script will use the list
#   of servers declared on the conf/slaves file and open an ssh to each one. Through this SSH
#   connection, the script will start the slaves on each node. This doesn't work because our
#   zeppelin node doesn't runn an ssh daemon.
# - By calling start-slave.sh directly: This works, but we need to pass the URL of the
#   server master. It can't be localhost because this resolves to an IP address outside 
#   of the weaver overlay network. That is why we are going to call hostname -f to determine
#   the correct server name:
#

sparkMasterURL="spark://$SPARK_MASTER_HOST:$SPARK_MASTER_PORT"

printf "\n\nStarting Spark Master...\n\n"
/usr/local/spark/sbin/start-master.sh

printf "\n\nStarting Spark Slave with master pointing to $sparkMasterURL...\n\n"
/usr/local/spark/sbin/start-slave.sh $sparkMasterURL

printf "\n\n Starting Zeppelin...\n\n"
/zeppelin/bin/zeppelin.sh
