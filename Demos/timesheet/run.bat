@ECHO OFF

echo Updating sub modules...
git submodule init
git submodule update

echo RUNNING...
docker-compose stop
docker-compose rm -f
docker-compose up