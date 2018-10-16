@ECHO OFF

echo Updating sub modules...
git submodule init
git submodule update

echo BUILDING...
docker-compose build

echo RUNNING...
docker-compose up