@ECHO OFF

for /D %%G in (*) do (
    if "%%~G" NEQ "tomcat" if "%%~G" NEQ "zeppelin-spark" (
        echo.
        echo ####################################
        echo Pushing Base Image %%~G
        echo ####################################
        echo.

        set IMAGE_NAME=amirsamary/irisdemo:%%~G

        cd %%~G
        docker push %IMAGE_NAME%
        cd ..
    )
)
