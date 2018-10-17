@ECHO OFF

for /d %%D in (*) do (
    cd %%~D
    call build.bat

    cd ..
)