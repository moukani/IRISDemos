@ECHO OFF

for /D %%G in (*) do (
    if "%%~G" NEQ "templates" if "%%~G" NEQ "mydemo" (
        echo.
        echo ####################################
        echo Building demo %%~G
        echo ####################################
        echo.

        cd %%~G
        call build.bat
        cd ..
    )
)
