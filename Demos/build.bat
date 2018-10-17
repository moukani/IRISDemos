@ECHO OFF
@setlocal enableextensions enabledelayedexpansion

for /d %%D in (*) do (
    set dirName=%%~D

    if (x%dirName:templates=%==x%dirName%) and (x%dirName:mydemo=%==x%dirName%) (
        cd %dirName%
        echo %dirName%
        rem build.bat
        cd ..
    )
)

@ECHO OFF
