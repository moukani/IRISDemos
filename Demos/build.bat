@ECHO OFF
@setlocal enableextensions enabledelayedexpansion

for /D %%G in (*) do (
    if "%%~G" NEQ "templates" if "%%~G" NEQ "mydemo" (
        cd %%~G
        build.bat
        cd ..
    )
)

endlocal