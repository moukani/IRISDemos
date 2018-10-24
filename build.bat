@ECHO OFF

echo.
echo Docker login:
echo.
docker login

echo.
echo #######################################
echo "Building Base Images"
cd BaseImages
call build.bat
cd ..

echo.
echo #######################################
echo "Building Demos"
cd Demos
call build.bat
cd ..
