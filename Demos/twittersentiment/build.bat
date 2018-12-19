@ECHO OFF

echo Updating sub modules...
git submodule init
git submodule update

echo BUILDING...
copy ..\..\IRISLicense\iris.key .\twittersentiment\
docker-compose stop
docker-compose rm -f
docker-compose build
