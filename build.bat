@ECHO OFF

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
