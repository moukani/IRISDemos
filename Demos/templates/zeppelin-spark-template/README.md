If you are building a new demo that requires Zeppelin/Spark connected to IRIS, 
then create your demo folder under *IRISDemoImages/Demos/<YourDemo>*. Then change
to this directory and execute the following:

``` shell
copy -r ../templates/zeppelin-spark-template ./<my zeppelin folder name>
```

Then, create your docker-compose.yml file under *IRISDemoImages/Demos/<YourDemo>* folder
and reference your new image from there.



