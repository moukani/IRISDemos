If you are building a new demo that requires IRIS Database or an IRIS Data Lake, 
then create your demo folder (if you haven't done it yet) under *IRISDemoImages/Demos/<YourDemo>*. 
Then change to this directory and execute the following:

``` shell
copy -r ../templates/irisdemoint-template ./<my iris db folder name>
```

On this folder, you will find an atelier project named *template-atelier-project*. 
Rename it to a more appropiate name. For instnce if *<my iris db folder name>* is *ACMEDataLake*
then try naming your atelier project *acmedatalake-atelier-project*:

``` shell
copy -r ../templates/irisdemodb-template ./ACMEDataLake
cd ./ERPintSrv
mv ./template-atelier-project ./acmedatalake-atelier-project
```

Then, create your docker-compose.yml file under *IRISDemoImages/Demos/<YourDemo>* folder
and reference your new image from there. Don't forget to specify the args directive under your
build directive in order to tell the image where to find your atelier project:

``` yml
    build: 
      context: ./ACMEDataLake
      args:
      - IRIS_PROJECT_FOLDER_NAME=acmedatalake-atelier-project
```

You can find an example of docker-compose.yml file under *IRISDemoImages/Demos/templates/ folder. 
Cut it and change it to your purposes.