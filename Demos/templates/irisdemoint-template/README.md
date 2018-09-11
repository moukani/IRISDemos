If you are building a new demo that requires IRIS Interoperability, 
then create your demo folder (if you haven't done it yet) under *IRISDemoImages/Demos/<YourDemo>*. 
Then change to this directory and execute the following:

``` shell
copy -r ../templates/irisdemoint-template ./<my iris int folder name>
```

On this folder, you will find an atelier project named *template-atelier-project*. 
Rename it to a more appropiate name. For instnce if *<my iris int folder name>* is *ACMEERPintSrv*
then try naming your atelier project *acmeerpintsrv-atelier-project*:

``` shell
copy -r ../templates/irisdemoint-template ./ACMEERPintSrv
cd ./ERPintSrv
mv ./template-atelier-project ./acmeerpintsrv-atelier-project
```

Then, create your docker-compose.yml file under *IRISDemoImages/Demos/<YourDemo>* folder
and reference your new image from there. Don't forget to specify the args directive under your
build directive in order to tell the image where to find your atelier project:

``` yml
    build: 
      context: ./ACMEERPintSrv
      args:
      - IRIS_PROJECT_FOLDER_NAME=acmeerpintsrv-atelier-project
```

You can find an example of docker-compose.yml file under *IRISDemoImages/Demos/templates/ folder. 
Cut it and change it to your purposes.