These are combinations of base images (irisdemo, tomcat, etc.) to build a stack. 

A simple "hello world like" application should be provided showing how the images can be used together.

The stack will be defined and built with a docker-compose.yml file that will reference as many Dockerfiles on sub folders as required to build the stack. Each Dockerfile will reference a base image if you don't need to build a custom new image.

Instructions on how to use it and start it should be provided on a README.md file on the stack's folder.

These stacks will later be public (to really everyone).