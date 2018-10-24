@ECHO OFF

echo.
echo Pushing Base Images
echo.

cd BaseImages
call push.bat
cd ..

echo.
echo Pushing Demos
echo.

cd Demos
call push.bat
cd ..
