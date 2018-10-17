@ECHO OFF

set IRIS_PROJECT_FOLDER_NAME=irisdemoint-atelier-project

for %%I in (.) do set CurrDirName=%%~nxI
set IMAGE_NAME=%CurrDirName%

docker build --build-arg IRIS_PROJECT_FOLDER_NAME=%IRIS_PROJECT_FOLDER_NAME% -t %IMAGE_NAME% .