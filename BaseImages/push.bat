@ECHO OFF

for /D %%G in (*) do (
    rem if "%%~G" NEQ "." if "%%~G" NEQ ".." (
    cd %%~G
    call push.bat
    cd ..
    rem )
)
