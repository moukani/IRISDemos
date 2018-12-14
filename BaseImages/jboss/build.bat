@ECHO OFF

for %%I in (.) do set CurrDirName=%%~nxI
set IMAGE_NAME=amirsamary/irisdemo:%CurrDirName%

docker build -t %IMAGE_NAME% .