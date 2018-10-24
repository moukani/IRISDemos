@ECHO OFF

echo.
echo Pushing Base Images
echo.

cd BaseImages
push
cd ..

echo.
echo Pushing Demos
echo.

cd Demos
push
cd ..
