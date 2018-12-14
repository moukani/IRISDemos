@ECHO OFF

for %%I in (.) do set CurrDirName=%%~nxI
set CONTAINER_NAME=%CurrDirName%

set IMAGE_NAME=amirsamary/irisdemo:%CONTAINER_NAME%

docker run --rm -it -p 8080:8080 -p 9990:9990 --name %CONTAINER_NAME% %IMAGE_NAME%