#!/bin/bash
#
# Amir Samary - 2018
#
# This script is included on practically all other scripts
#

#
# CONSTANTS
#
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

#
# Utility functions
#
function showError() {
    red
    printf "\nERROR: $1\n"
    nocolor
}

function showMessage() {
    green
    printf "\n$1\n"
    nocolor
}

function printfY() {
    yellow
    printf "$1"
    nocolor
}

function printfR() {
    red
    printf "$1"
    nocolor
}

function printfG() {
    green
    printf "$1"
    nocolor
}

function nocolor() {
    printf "${NC}"
}

function yellow() {
    printf "${YELLOW}"
}

function red() {
    printf "${RED}"
}

function green() {
    printf "${GREEN}"
}

function checkContainer() {

    printfY "\nChecking service $service...\n"
    if docker logs $container --tail 30 2>&1 | grep 'errors during journal rollback'
    then
        docker logs $container --tail 30 2>&1 | grep 'errors during journal rollback'
        
        printfR "\nFound unrecoverable error on service $service. Try building the service again...\n"

        docker rmi -f ${PWD##*/}_$service
        docker-compose build $service
        docker-compose start $service
        sleep 10

        checkContainer
    fi

    if docker logs $container --tail 30 2>&1 | grep -E '(PROTECT|Shutting down the system)'
    then
        docker logs $container --tail 30 2>&1 | grep -E '(PROTECT|Shutting down the system)'
        
        printfR "\nFound PROTECT error on service $service. Restarting this container...\n"
        docker-compose restart $service
        sleep 10

        checkContainer
    fi
}

function startAndCheckContainers()
{
    printfY "\nCreating containers...\n"
    docker-compose up --no-start

    printfY "\nStarting containers...\n"
    docker-compose start
    sleep 15

    demoname=${PWD##*/}

    for container in `docker-compose ps | grep $demoname | awk '{print $1}'`
    do
        service=$(echo $container | cut -d'_' -f 2)
        checkContainer
    done

    printfG "\n\n ALL services started!\n\n"
}
# Can receive one parameter with the docker registry to log in to.
function dockerLogin() {
    printf "\n\nDocker Credentials:\n"
    printf "\n\tLogin   : "
    read dockerUsername
    printf "\tPassword: "
    stty -echo
    read dockerPassword
    stty echo
    printf "\n\n"

    if [ -z "$dockerUsername" ]
    then
        printfR "\n\nABORTING: Docker username is required.\n\n"
        exit 1
    fi

    if [ -z "$dockerPassword" ]
    then
        printfR "\n\nABORTING: Docker password is required\n\n"
        exit 1
    fi

    printfY "\n\nLogging in...\n"
    if [ -z "$1" ]
    then
        printfY "\n\nTrying to log in on docker hub...\n"
        docker login -u $dockerUsername -p $dockerPassword
    else
        printfY "\n\nTrying to log in on $1...\n"
        docker login -u $dockerUsername -p $dockerPassword $1
    fi
    
    if [ $? -eq 0 ]; then 
        printfG "\nLogin successful.\n"
    else
        printfR "\nLogin failed. \n"
        exit 1
    fi
}

function verifyVPC() {
    cat /ICM/etc/Terraform/GCP/VPC/infrastructure.tf | grep jupyter
    if [ $? -eq 1 ]
    then
        prinfY "\n\nAdding Additional Firewall Rules to ICM for GCP...\n\n" 
        cat /irisdemo/templates/GCP/infrastructure.tf >> /ICM/etc/Terraform/GCP/VPC/infrastructure.tf
    fi
}

# checkError(errorMsg, successMsg)
# 
# If last command terminated with an error, prints errorMsg and exits with error returned.
# IF last command did not terminated with an error, prints successMsg.
function checkError() {
    if [ ! $? -eq 0 ]
    then 
        printfR "\n$1\n"
        exit $?
    else
        if [ ! -z "$2" ]
        then
            printfG "\n$2\n"
        fi
    fi
}

# stripQuotes(str)
#
# strips quotes from beggining and end of string. It must be called like this:
#
# myString=$(stripQuotes "\"some text between quotes\"")
#
function stripQuotes() {
    
    stringWithoutQuotes="${1%\"}"  # ${opt%\"} will remove the suffix " (escaped with a backslash to prevent shell interpretation)

    stringWithoutQuotes="${stringWithoutQuotes#\"}"  # ${temp#\"} will remove the prefix " (escaped with a backslash to prevent shell interpretation)

    echo $stringWithoutQuotes
}