@ECHO OFF

docker run --rm -it -p 51773:51773 -p 52773:52773 -v $PWD/shared:/shared --name $CONTAINER_NAME $IMAGE_NAME --key /shared/license.key