# IRIS Interoperability Image

This is a basic IRIS Interoperability image. It is used by all stacks that need interoperability. *Do not use it directly!* The instance is configured with the password "sys". You can log into the management portal with the SuperUser account. 

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
            └─── irisdemoint 
                 ├── shared  
                 │   └── license.key  
                 ├── build.sh
                 ├── Dockerfile  
                 ├── README.md  
                 ├── run.sh
                 ├── runinstaller.sh

## The out of the box Production and how to customize this image with source code

There is an Atelier project on folder ./irisdemoint-atelier-project. You can add your classes to it. This project already brings an empty production called IRISDemo.Production. This production is configured by the Installer Manifest (IRISDemo.SYS.Installer) to auto-start with the container.

When you rebuild the Dockerfile into a new image, this source code will be cooked into the container.

Once you get the container running, you can open the out-of-the-box production configuration page on http://localhost:52773/csp/appint/EnsPortal.ProductionConfig.zen. Your production should already be running. Just add services, processes and operations to it!

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

Let's say you are a demo application with this image. Create a folder for your new application under the *Demos* folder to hold your new demo. Let's call it "MyNewAwesomeDemo":

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
        │       │   └─── Dockerfile  
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
FROM amirsamary/irisdemo:irisdemoint
LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

#Your customizations to the image go here!
```

You will use this dockerfile to further customize IRIS (by adding source code, data, etc.) for the purposes of your Demo. 

On the root of your new folder, add a docker-compose.yml file that will define your stack.

# Environment Variables for External Services

Demos built with this image should expect to find an IRIS Database located here (if you added one to your stack or demo):

* IRIS_MASTER_HOST=iris  
* IRIS_MASTER_PORT=51773
* IRIS_MASTER_WEBPORT=52773
* IRIS_MASTER_USERNAME=SuperUser 
* IRIS_MASTER_PASSWORD=sys
* IRIS_MASTER_NAMESPACE=INT

You may need to connect to it via JDBC, REST or SOAP for your demo purposes. You can have these default values hard coded on YOUR code or you can pass them to your container on your docker-compose.yml file and change your code to get these values using:

``` asp
Set IRISIntHost = $System.Util.GetEnviron("IRIS_MASTER_HOST")
```
