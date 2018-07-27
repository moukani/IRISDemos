# IRIS Interoperability Image

This is a basic IRIS Interoperability image. It is used by all stacks that need interoperability. *Do not use it directly!* The instance is configured with the password "sys". You can log into the management portal with the SuperUser account. 

This image is based on a production image of IRIS but is pre-configured with a default password and CSP applications to make demos easier to build. If you are building a custom application based on this image, change your Dockerfile to remove the default password, change the Installer Manifest to adapt it to your needs and review the CSP application cofigurations to set it up accordingly to your requirements. 

## How to build the image

You should only build this image if you are working on improving it. Otherwize, create a new Dockerfile based on this one. See instructions on the following topics for that.

The image can be easily built by running:

``` shell
./build.sh
```

It will run docker build and create an image with the name of the folder you are in. There is an Atelier project on folder ./irisdemoint-atelier-project. You can add your classes to it. This project already brings an empty production called IRISDemo.Production. This production is configured by the Installer Manifest (IRISConfig.Installer) to auto-start with the container.

If you want to push it to docker hub, run with the push parameter:

``` shell
./build.sh push
```

The script will ask for your Docker Hub username and password. This is a temporary feature. It will last until we have a CI pipeline configured to automatically build the image upon new commits to the GitHub repository.

If you are maintaining *this* image, it is important to know that it is on the build.sh file that we specify the name of the folder where the source code we want inside the image is loaded from:

``` shell
#!/bin/sh

IRIS_PROJECT_FOLDER_NAME=irisdemoint-atelier-project

source ../../ShellScriptUtils/util.sh
source ../../ShellScriptUtils/buildandpush.sh

if [ -z "$1" ]
then
    buildAndPush --build-arg IRIS_PROJECT_FOLDER_NAME=$IRIS_PROJECT_FOLDER_NAME
else
    buildAndPush $1 --build-arg IRIS_PROJECT_FOLDER_NAME=$IRIS_PROJECT_FOLDER_NAME
fi
```

It is from this project folder where we load class IRISDemo.Production with the empty production and IRISDemo.SYS.Installer with a manifest that, between other things, configure this production to start automatically. Our demos will use this example production and we will not be copying this Dockerfile but inheriting from it with the FROM Dockerfile clause. 

## How to run the image

If you are working to improve this image and need to test it. An example on how to run this image can be found on shell script run.sh. You can call:

``` shell
./run.sh
```

The script will create an emphemeral container with the name of the folder you are in (irisdemoint) and let you know where the management portal is. If you need help, just run:

``` shell
./run.sh --help
```

## The out of the box Production

Once you get the container running, you can open the out-of-the-box production configuration page on http://localhost:52773/csp/appint/EnsPortal.ProductionConfig.zen.

You should not customize this image. Follow procedures bellow to create your own image based on this.

## Specifying the IRIS license

The script will verify if a folder called *./shared* exists. If it doesn't, it will create it for you. this folder will be mapped to the /shared folder into your container. If you put a file called license.key on this folder, IRIS will use it. Otherwise, the IRIS will run without a license:

    git  
    └── IRISDemoImages  
        └── BaseImages  
            └─── irisdemoint 
                 ├── shared  
                 │   └── license.key  
                 ├── build.sh
                 ├── Dockerfile  
                 ├── README.md  
                 ├── run.sh
                 ├── runinstaller.sh

## Specifying your namespace

The Dockerfile contains an environment variable called IRIS_APP_NAME. This variable is used to:

* Create a new namespace and a database for it (a database in this context is where you 
  store your production configuration and data)
* Create a new CSP application for managing your production
* Create a new REST CSP application for your REST services
* Create a new SOAP CSP application for your SOAP services

Your source code will be loaded into this namespace. The SOAP CSP is unauthenticated. You should further restrict it with PermittedClasses on it and use SOAP Security Configurations.

The REST CSP application requires authentication and uses cookies to keep remember who is calling. It has already a PermittedClasses configuration as an initial example.

Pending: 
* Provide a simple REST service to call as a hello world service. 
* Provide a simple SOAP service to call as a hello world service.

## Building an Application with this Image

Let's say you are building a demo application with this image. Create a folder for your new application under the *Demos* folder to hold your new demo. Let's call it "MyNewAwesomeDemo":

    git  
    └── IRISDemoImages  
        ├── BaseImages  
        │
        ├── Demos  
        │   └─── MyNewAwesomeDemo  
        │       ├── docker-compose.yml  
        │       │
        │       ├── irisdb  
        │       │   └─── Dockerfile  
        │       │
        │       ├── irisint  
        │       │   ├─── Dockerfile  
        │       │   └─── my-project  
        │       │
        │       ├── tomcat  
        │       │   └─── Dockerfile  
        │       │
        │       └─── README.md  
        │
        └── Stacks  

Now add as many sub-folders under *MyNewAwesomeApp* as the number of images on your Application. 

On the subfolder for the irisint image, create a Dockerfile that has on its FROM clause a reference for the irisdemoint image:

``` yaml
FROM amirsamary/irisdemo:irisdemodb
LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# Name of the project folder ex.: my-atelier-project
ARG IRIS_PROJECT_FOLDER_NAME

# Adding source code that will be loaded by the installer
ADD ./${IRIS_PROJECT_FOLDER_NAME}/ $IRIS_APP_SOURCEDIR

# Running the installer.
RUN /usr/irissys/demo/irisdemoinstaller.sh```

You will use this dockerfile to further customize IRIS (by adding source code, data, etc.) for the purposes of your Demo. Copy the irisdemoint-atelier-project with the demo source code as a starting point. 

On the root of your new folder, add a docker-compose.yml file that will define your stack with all these images. Then, use the IRIS_PROJECT_FOLDER_NAME argument when configuring your docker-compose file to build the image pointing to your project file. Here is an example of a docker-compose.yml:

``` yaml
version: '3.6'
services:
  irisint:
    build: 
      context: ./irisint
      args:
      - IRIS_PROJECT_FOLDER_NAME=iris_project
    image: tomcat-irisint
    command: --key /shared/license.key
    hostname: irisint
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
    - IRIS_MASTER_HOST=irisint # DNS based on the name of the SERVICE!
    - IRIS_MASTER_PORT=51773 
    - IRIS_MASTER_USERNAME=SuperUser 
    - IRIS_MASTER_PASSWORD=sys 
    - IRIS_MASTER_NAMESPACE=USER 

```

If you build and run this docker-compose file, you will have a production called IRISDemo.Production running. You will be able to connect to it using Atelier. You can open your project with Atelier and add services, business processes and business operations to it. Your source code is stored outside of your container, but Atelier also synchronizes it with the container.

If you don't want your production to be called IRISDemo.Production or if you want to call your namespace something else, you will want to copy the original *irisdemoint* Dockerfile source code into your Dockerfile instead of simply inheriting from *irisdemoint* image. 

# Environment Variables for External Services

Demos built with this image should expect to find an IRIS Database located here (if you added one to your stack or demo):

* IRIS_MASTER_HOST=irisdb  
* IRIS_MASTER_PORT=51773
* IRIS_MASTER_WEBPORT=52773
* IRIS_MASTER_USERNAME=SuperUser 
* IRIS_MASTER_PASSWORD=sys
* IRIS_MASTER_NAMESPACE=INT

You may need to connect to it via JDBC, REST or SOAP for your demo purposes. You can have these default values hard coded on YOUR code or you can pass them to your container on your docker-compose.yml file and change your code to get these values using:

``` asp
Set IRISIntHost = $System.Util.GetEnviron("IRIS_MASTER_HOST")
```