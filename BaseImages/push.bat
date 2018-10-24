@ECHO OFF

for /D %%G in (*) do (
    if "%%~G" NEQ "." if "%%~G" NEQ ".." (
        cd %%~G
        call push.bat
        cd ..
    )
)
