@ECHO OFF

IRIS_PROJECT_FOLDER_NAME=irisdemodb-atelier-project

docker build --build-arg IRIS_PROJECT_FOLDER_NAME=$IRIS_PROJECT_FOLDER_NAME --force-rm -t $IMAGE_NAME .