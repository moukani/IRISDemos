@ECHO OFF

echo "Building Base Images"
cd BaseImages
build.bat
cd ..

echo "Building Demos"
cd Demos
build.bat
cd ..
