@ECHO OFF

for %%I in (.) do set CurrDirName=%%~nxI
set IMAGE_NAME=amirsamary/irisdemo:%CurrDirName%

docker build --force-rm -t %IMAGE_NAME% .