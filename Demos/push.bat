@ECHO OFF

for /D %%G in (*) do (
    if "%%~G" NEQ "templates" if "%%~G" NEQ "mydemo" (
        cd %%~G
        call push.bat
        cd ..
    )
)
