# IRIS Database Image

This is a basic IRIS Database image. It is used by all stacks that need a database. *Do not use it directly!* The instance is configured with the password "sys". You can log into the management portal with the SuperUser account. 

## How to run the image

If you are working to improve this image and need to test it. An example on how to run this image can be found on shell script run.sh. You can call:

``` shell
run.sh --help
```

The script will tell you what you need to know.

## Building a Stack with this Image

If you are building a stack with this image, create a folder under the Stacks folder to hold your stack. Your stack will have two or more images. So create two or more folders under your new folder, one for each image:

    git  
    ├── IRISDemoImages  
    │   ├── BaseImages  
    │   ├── Stacks  
    │   │   ├── MyNewStack  
    │   │   │   ├── docker-compose.yml  
    │   │   │   ├── irisdb  
    │   │   │   │   ├── Dockerfile  
    │   │   │   ├── other_image  
    │   │   │   │   ├── Dockerfile  
    │   │   │   ├── another_image  
    │   │   │   │   ├── Dockerfile  
    │   │   │   ├── README.md  
    │   └── Demos  

On the subfolder for the irisdb image, create a Dockerfile that has on its FROM clause a reference for the irisdemodb image:

``` yaml
FROM amirsamary/irisdemo:irisdemodb
LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

#Your customizations to the image go here!
```

You will use this dockerfile to further customize IRIS (by adding source code, data, etc.) for the purposes of your Stack. 

On the root of your new folder (MyNewStack), add a docker-compose.yml file that will define your stack.

## Environment Variables

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