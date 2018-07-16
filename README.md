# IRIS Demo Repository

This repository holds the source code of all IRIS Demos. The demos are to be run with docker compose. Each demo is based on a stack. So, for instance, if you have a demo that is based on IRIS Database, IRIS Interoperability and Zeppelin/Spark, you would probably be combining the [ml](./Stacks/ml/) stack with the [IRIS Interoperability](./BaseImages/irisdemoint/) image.

##[BaseImages](./BaseImages)

This folder contain the base images used to build stacks and demos. Normally a demo is built upon a stack, but if it is simple enough, a demo can be built with a single base image. On more complex scenarios, a demo may compose one stack with an additional image. Any combination is possible. The only thing to have in mind is that the images are the basic building blocks of demos.

You may be asking why do we need to build our own images. Let's give an example: The [irisdemoint](./BaseImages/irisdemodb/) image comes pre-configured with:
* Password - The default password "sys" is configured for SuperUser
* Namespace - A namespace called APPINT for the code of your demo
* Production - A default IRISDemo.Production that is configured to auto-start with the instance
* SOAP Application - A /csp/appint/soap CSP application to expose your SOAP services with the proper security.
* REST Application - A /csp/appint/rest CSP application and an empty IRISDemo.REST.Dispatcher to expose your REST services with the proper security
* Installer - To load your source code from your Atelier project

So, when building a demo of IRIS Interoperability, all you would have to do is to create a folder for your demo under the Demos folder, create your own Dockerfile based on irisdemodb. Then you create an Atelier project on this folder and build your image following the documentation! No need to configure anythign else!

Another example of why building our own image is important: The Zeppelin-Spark image is a an image that brings Zeppelin and Spark cooked together. It is perfect for demoing Spark, Python, Scala and JDBC with IRIS. It is based on the standard apache zeppelin image. But we add to it IRIS JDBC and IRIS Spark connectors. We have also added configurations and parameters that allows you to simply start this image and use it against your IRIS installation. It just works! No configuration needed.

##[Stacks](./Stacks)

A stack is a combination of images. It gives you a docker-compose.yml file combining two or more instances. For instance, the [ml](./Stacks/ml/) stack combines the Zeppelin/Spark image with the IRIS Database Image. All you have to do to start Zeppelin, Spark and IRIS is to run *docker-compose up* on your folder! The Zeppelin notebook and Spark will already know where your IRIS instance is. You can easily build a demo with this by adding your classes and data to IRIS and notebooks to Zeppelin. 

Other examples of stacks:
* REACT/Tomcat with IRIS Database using REST or JDBC to communicate (2 images)
* Angular/Node.js with IRIS Database and IRIS Interoperability using IRIS DocDB and REST to communicate (3 images)
* Bootstrap/PHP with IRIS Database using REST to communicate (2 images)
* Django with IRIS Database using REST to communicate (2 images)

You can build a demo by taking one of those base stacks and combining it with one or more  images into your demo folder. Just pull them together into your docker-compose file! A stack is there just to give you examples of how to combine them. Think of stacks as templates for your demo!

##[Demos](./Demos)

Demos are mini applications built on top of a stack and other images combined. To create a demo, just copy a Stack into a new folder under the Demos folder. Add your source code as appropiate and run it! All the configurations required in terms of drivers, connectivity, security, etc. are sorted out. You should just worry about adding your source code and data to right images.
