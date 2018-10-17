@ECHO OFF

for %%I in (.) do set CurrDirName=%%~nxI
set CONTAINER_NAME=%CurrDirName%

set IMAGE_NAME=amirsamary/irisdemo:%CONTAINER_NAME%

docker run --rm -it -p 51773:51773 -p 52773:52773 -v %cd%\shared:/shared -v %cd%\..\..\\IRISLicense:/irislicense --name %CONTAINER_NAME% %IMAGE_NAME% --key /irislicense/iris.key