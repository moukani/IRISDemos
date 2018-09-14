A demo will often combine many images. For instance, if you are building an Angular application you will
probably have an image for your Node.js server and another for the IRIS Stateful Services (your database).

You may then decide to add interoperability services to this demo and have a third image with and IRIS 
Interoperability Production running on it.

This folder contains templates you can copy and paste into your *Demos/<YOUR DEMO FOLDER>* folder to create
your demos. You will start all these images together on your machine using docker compose. So, we have also 
provided a *docker-compose-template.yml* file that you can rename to docker-compose.yml on your demo folder
and use *docker-compose build* to build it.