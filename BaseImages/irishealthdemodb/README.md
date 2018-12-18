# IRIS Database Image

This is a basic IRIS Database image. It is used by all stacks that need a database. *Do not use it directly!* The instance is configured with the password "sys". You can log into the management portal with the SuperUser account. 

This image is based on a production image of IRIS but is pre-configured with a default password and CSP applications to make demos easier to build. If you are building a custom application based on this image, change your Dockerfile to remove the default password, change the Installer Manifest to adapt it to your needs and review the CSP application cofigurations to set it up accordingly to your requirements. 

## How to build the image

You should only build this image if you are working on improving it. Otherwize, create a new Dockerfile based on this one. See instructions on the following topics for that.

The image can be easily built by running:

``` shell
./build.sh
```

It will run docker build and create an image with the name of the folder you are in. There is an Atelier project on folder ./irisdemodb-atelier-project. You can add your classes to it. This project brings a hello world CSP page and a Installer Manifest (IRISDemo.SYS.Installer) to configure namespaces, databases and security aspects of your application.

If you want to push it to docker hub, run with the push parameter:

``` shell
./build.sh push
```

The script will ask for your Docker Hub username and password. This is a temporary feature. It will last until we have a CI pipeline configured to automatically build the image upon new commits to the GitHub repository.

If you are maintaining *this* image, it is important to know that it is on the build.sh file that we specify the name of the folder where the source code we want inside the image is loaded from:

``` shell
#!/bin/sh

IRIS_PROJECT_FOLDER_NAME=irisdemodb-atelier-project

source ../../ShellScriptUtils/util.sh
source ../../ShellScriptUtils/buildandpush.sh

if [ -z "$1" ]
then
    buildAndPush --build-arg IRIS_PROJECT_FOLDER_NAME=$IRIS_PROJECT_FOLDER_NAME
else
    buildAndPush $1 --build-arg IRIS_PROJECT_FOLDER_NAME=$IRIS_PROJECT_FOLDER_NAME
fi
```

It is from this project folder where we load the hello world CSP page and IRISConfig.Installer with a manifest. Our demos will use this example namespace and we will not be copying this Dockerfile but inheriting from it with the FROM Dockerfile clause. 

## How to run the image

If you are working to improve this image and need to test it. An example on how to run this image can be found on shell script run.sh. You can call:

``` shell
./run.sh
```

The script will create an emphemeral container with the name of the folder you are in (irisdemodb) and let you know where the management portal is. If you need help, just run:

``` shell
./run.sh --help
```

## Specifying the IRIS license

The script will mount the folder *IRISLicense* inside the container's */irislicense* folder. There should exist an iris.key file in there with your IRIS License.

    git  
    └── IRISDemoImages  
        └── IRISLicense  
            └─── iris.key  
        └── BaseImages  
            └─── irisdemodb  
                 ├── build.sh
                 ├── Dockerfile  
                 ├── README.md  
                 ├── run.sh
                 ├── runinstaller.sh

## Calling the Hello IRIS page

The Dockerfile will add source code from your project into the image. You specify the name of the project with the argument IRIS_PROJECT_FOLDER_NAME.
The build.sh shows how to build the image passing this argument. This image will use a demo project we have created, with a simple hello world web page
to show how the mechanism can be used. 

After running the container, open it on http://localhost:52773/csp/app/hello.csp.

## Specifying your namespace

The Dockerfile contains an environment variable called IRIS_APP_NAME. This variable is used to:

* Create a new namespace and a database for it
* Create a new CSP application for it
* Create a new REST CSP application for it

Your source code will be loaded into this namespace and CSP application. So make sure your source code CSP directory structure matches the name of your application.

## Building a Stack with this Image

Let's say you are building an equivalent of the LAMP stack (Linux, Apache, MySQL and PHP) but replacing MySQL for IRIS. Let's call it *_LIPA stack_*.

Create a folder called LIPA under the *Stacks* folder to hold your new stack:

    git  
    └── IRISDemoImages  
        ├── BaseImages  
        │
        ├── Stacks  
        │   └─── LIPA  
        │       ├── docker-compose.yml  
        │       │
        │       ├── irisdb  
        │       │   └─── Dockerfile  
        │       │
        │       ├── php  
        │       │   └─── Dockerfile  
        │       │
        │       └─── README.md  
        │
        └── Demos  

Now add as many sub-folders under *LIPA* as the number of images on your Stack. 

On the subfolder for the irisdb image, create a Dockerfile that has on its FROM clause a reference for the irisdemodb image:

``` yaml
FROM amirsamary/irisdemo:irisdemodb
LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# Name of the project folder ex.: my-atelier-project
ARG IRIS_PROJECT_FOLDER_NAME

# Adding source code that will be loaded by the installer
ADD ./${IRIS_PROJECT_FOLDER_NAME}/ $IRIS_APP_SOURCEDIR

# Running the installer.
RUN /usr/irissys/demo/irisdemoinstaller.sh
```

You will use this dockerfile to further customize IRIS (by adding source code, data, etc.) for the purposes of your Stack or Demo. Copy the irisdemoint-atelier-project with the demo source code as a starting point. 

On the root of your new folder, add a docker-compose.yml file that will define your stack with all these images. Then, use the IRIS_PROJECT_FOLDER_NAME argument when configuring your docker-compose file to build the image pointing to your project file. Here is an example of a docker-compose.yml:

``` yaml
version: '3.6'
services:
  irisdb:
    build: 
      context: ./irisdb
      args:
      - IRIS_PROJECT_FOLDER_NAME=iris_project
    image: tomcat-irisdb
    command: --key /shared/license.key
    hostname: irisdb
    environment:
    - ISC_DATA_DIRECTORY=/shared/iris
    ports:
    # 51773 is the superserver default port
    - "9091:51773"
    # 52773 is the webserver/management portal port
    - "9090:52773"
    volumes:
    - ${PWD}/iris/shared/:/shared

  app:
    image: tomcat-app
    build: 
      
      context: ./tomcat
    ports:
    - "9095:8080"   # Tomcat
    volumes:
    - $PWD/tomcat/shared/:/shared
    environment:
    - IRIS_MASTER_HOST=irisdb # DNS based on the name of the SERVICE!
    - IRIS_MASTER_PORT=51773 
    - IRIS_MASTER_USERNAME=SuperUser 
    - IRIS_MASTER_PASSWORD=sys 
    - IRIS_MASTER_NAMESPACE=USER 

```

If you build and run this docker-compose file, you will the hello iris CSP page plus your source code. You will be able to connect to it using Atelier. You can open your project with Atelier and add more classes, REST services, SOAP services and CSP pages to it. Your source code is stored outside of your container, but Atelier also synchronizes it with the container.

If you don't want the hello iris CSP page or if you want to call your namespace something else, you will want to copy the original *irisdemodb* Dockerfile source code into your Dockerfile instead of simply inheriting from *irisdemodb* image. 

# Environment Variables for External Services

Demos built with this image should expect to find an IRIS Interoperability container located here (if you added one to your stack or demo):

* IRISINT_MASTER_HOST=irisint 
* IRISINT_MASTER_PORT=51773
* IRISINT_MASTER_WEBPORT=52773
* IRISINT_MASTER_USERNAME=SuperUser 
* IRISINT_MASTER_PASSWORD=sys
* IRISINT_MASTER_NAMESPACE=INT

 Your IRIS code will later be able to call the following code to get these values:

``` asp
Set IRISIntHost = $System.Util.GetEnviron("IRISINT_MASTER_HOST")
```

You may need to connect to it via REST or SOAP for the purposes of your demo. You can have these default values hard coded on YOUR code or you can pass them to your container on your docker-compose.yml file and change your code to get these values using:

``` asp
Set IRISIntHost = $System.Util.GetEnviron("IRISINT_MASTER_HOST")
```
