# IRIS Database Image

This is a basic IRIS Database image. It is used by all stacks that need a database. *Do not use it directly!* The instance is configured with the password "sys". You can log into the management portal with the SuperUser account. 

## How to run the image

If you are working to improve this image and need to test it. An example on how to run this image can be found on shell script run.sh. You can call:

``` shell
./run.sh
```

The script will create an emphemeral container and let you know where the management portal
is. If you need help, just run:

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

To test if your container is running and loading the source code correctly, you can call the hello IRIS page on http://localhost:52773/csp/app/hello.csp.


## How to customize this image with source code

Ther is an Atelier project on folder ./irisdemodb-atelier-project. You can add your classes and CSP pages to it. This project already brings the "Hello IRIS" page as an example.

When you rebuild the Dockerfile into a new image, this source code will be cooked into the container.

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

This image can contain code that will be calling an IRIS Demo Interoperability based container. Here are the environment variables that you can define for this purpose:

* IRISINT_MASTER_HOST=irisint 
* IRISINT_MASTER_PORT=51773
* IRISINT_MASTER_USERNAME=SuperUser 
* IRISINT_MASTER_PASSWORD=sys
* IRISINT_MASTER_NAMESPACE=INT

 Your IRIS code will later be able to call the following code to get these values:

``` asp
Set IRISIntHost = $System.Util.GetEnviron("IRISINT_MASTER_HOST")
```