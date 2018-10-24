@ECHO OFF

for /d %%D in (*) do (
    if "%%~D" NEQ "tomcat" if "%%~D" NEQ "zeppelin-spark" (
        echo.
        echo ####################################
        echo Building Base Image %%~D
        echo ####################################
        echo.

        cd %%~D
        call build.bat

        cd ..
    )
)