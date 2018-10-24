@ECHO OFF

for /D %%G in (*) do (
    if "%%~G" NEQ "templates" if "%%~G" NEQ "mydemo" (
        echo.
        echo ####################################
        echo Pushing Demo %%~G
        echo ####################################
        echo.

        cd %%~G
        call push.bat
        cd ..
    )
)
