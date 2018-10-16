@ECHO OFF

for %%I in (.) do set CurrDirName=%%~nxI
set CONTAINER_NAME=%CurrDirName%

set IMAGE_NAME=amirsamary/irisdemo:%CONTAINER_NAME%

docker run --rm -it -p 4200:4200 --name %CONTAINER_NAME% %IMAGE_NAME%