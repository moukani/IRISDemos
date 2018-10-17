@ECHO OFF

for /d %%D in (*) do (
    set originalDirName=%%~D

    if (x%originalDirName:templates=%==x%originalDirName%) and (x%originalDirName:mydemo=%==x%originalDirName%) (
        cd %%~D
        build.bat
        cd ..
    )
)