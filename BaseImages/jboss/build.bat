@ECHO OFF

echo Updating sub modules...
git submodule init
git submodule update

echo Building Hibernate Dialect Jar file on base image...
hibernate.build.bat

echo Building Image...
for %%I in (.) do set CurrDirName=%%~nxI
set IMAGE_NAME=amirsamary/irisdemo:%CurrDirName%

docker build -t %IMAGE_NAME% .