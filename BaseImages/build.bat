@ECHO OFF

for /d %%D in (*) do (
    cd %%~D
    build.bat

    cd ..
)