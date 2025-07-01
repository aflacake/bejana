@echo off
echo Installing Bejana...

set TARGET_DIR=%USERPROFILE%\.bejana

if not exist %TARGET_DIR% mkdir %TARGET_DIR%
xcopy * %TARGET_DIR% /E /I /Y >nul

echo @echo off > %TARGET_DIR%\bejana.cmd
echo ruby "%TARGET_DIR%\bejana.rb" %%* >> %TARGET_DIR%\bejana.cmd

set PATH=%PATH%;%TARGET_DIR%

echo.
echo Bejana berhasil diinstal di %TARGET_DIR%
echo Jalankan dengan: %TARGET_DIR%\bejana.cmd bantuan
