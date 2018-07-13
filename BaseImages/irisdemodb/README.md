# IRIS Database Image

This is a basic IRIS Database image. It is used by all stacks that need a database. *Do not use it directly!* The instance is configured with the password "sys". You can log into the management portal with the SuperUser account. 

## How to build the image

The image can be easily built by running:

``` shell
./build.sh
```

If you want to push it to docker hub, run with the push parameter:

``` shell
./build.sh push
```

The script will ask for your Docker Hub username and password. This is a temporary feature. It will last until we have a CI pipeline configured to automatically build the image upon new commits to the GitHub repository.

## How to customize this image with source code

There is an Atelier project on folder ./irisdemodb-atelier-project. You can add your classes and CSP pages to it. This project already brings the "Hello IRIS" page as an example.

When you rebuild the Dockerfile into a new image, this source code will be cooked into the container. On stacks and demos built with this image, you may want to use a different folder for your project. The folder most be at the level of the docker file project but you can call it any way you want. Then, change *your* build.sh file so it will reference this folder instead of "irisdemodb-atelier-project". Here is an example of a modified ./build.sh script for a stack:

``` shell
#!/bin/sh

#IRIS_PROJECT_FOLDER_NAME=irisdemodb-atelier-project
IRIS_PROJECT_FOLDER_NAME=my_project

source ../../ShellScriptUtils/util.sh
source ../../ShellScriptUtils/buildandpush.sh

if [ -z "$1" ]
then
    buildAndPush --build-arg IRIS_PROJECT_FOLDER_NAME=$IRIS_PROJECT_FOLDER_NAME
else
    buildAndPush $1 --build-arg IRIS_PROJECT_FOLDER_NAME=$IRIS_PROJECT_FOLDER_NAME
fi
```

## How to run the image

If you are working to improve this image and need to test it. An example on how to run this image can be found on shell script run.sh. You can call:

``` shell
./run.sh
```

The script will create an ephemeral container and let you know where the management portal is. If you need help, just run:

``` shell
./run.sh --help
```

## Specifying the IRIS license

The script will verify if a folder called *./shared* exists. If it doesn't, it will create it for you. this folder will be mapped to the /shared folder into your container. If you put a file called license.key on this folder, IRIS will use it. Otherwise, the IRIS will run without a license:

    git  
    └── IRISDemoImages  
        └── BaseImages  
            └─── irisdemodb  
                 ├── shared  
                 │   └── license.key  
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

#Your customizations to the image go here!
```

You will use this dockerfile to further customize IRIS (by adding source code, data, etc.) for the purposes of your Stack. 

On the root of your new folder (MyNewStack), add a docker-compose.yml file that will define your stack.

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
