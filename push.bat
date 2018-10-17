@ECHO OFF

echo "Building Base Images"
cd BaseImages
push.bat
cd ..

echo "Building Demos"
cd Demos
push.bat
cd ..
