@echo off
title FULL TEMP CLEANER
color 0A

echo Cleaning system and user temp folders...
echo.

:: Stop common services that lock temp files
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
net stop cryptsvc >nul 2>&1

:: User temp
echo USER TEMP:
del /f /s /q "%TEMP%\*" >nul 2>&1
for /d %%i in ("%TEMP%\*") do rd /s /q "%%i" >nul 2>&1

:: Windows temp
echo WINDOWS TEMP:
del /f /s /q "C:\Windows\Temp\*" >nul 2>&1
for /d %%i in ("C:\Windows\Temp\*") do rd /s /q "%%i" >nul 2>&1

:: SoftwareDistribution (Windows Update cache)
echo SOFTWARE DISTRIBUTION:
del /f /s /q "C:\Windows\SoftwareDistribution\*" >nul 2>&1
for /d %%i in ("C:\Windows\SoftwareDistribution\*") do rd /s /q "%%i" >nul 2>&1

:: Prefetch
echo PREFETCH:
del /f /s /q "C:\Windows\Prefetch\*" >nul 2>&1

:: Windows Error Reporting
echo WER:
del /f /s /q "C:\ProgramData\Microsoft\Windows\WER\*" >nul 2>&1
for /d %%i in ("C:\ProgramData\Microsoft\Windows\WER\*") do rd /s /q "%%i" >nul 2>&1

:: System logs
echo SYSTEM LOGS:
del /f /s /q "C:\Windows\Logs\*" >nul 2>&1
for /d %%i in ("C:\Windows\Logs\*") do rd /s /q "%%i" >nul 2>&1

:: Windows Installer cache (safe)
echo INSTALLER CACHE:
del /f /s /q "C:\Windows\Installer\$PatchCache$\*" >nul 2>&1

:: Edge / Chrome / Chromium cache
echo BROWSER CACHE:
for %%b in (
    "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache"
    "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache"
    "%LOCALAPPDATA%\Chromium\User Data\Default\Cache"
) do (
    del /f /s /q "%%b\*" >nul 2>&1
    for /d %%i in ("%%b\*") do rd /s /q "%%i" >nul 2>&1
)

:: Old Windows update leftovers
echo CLEANING WINDOWS UPDATE LEFTOVERS:
del /f /s /q "C:\Windows\WinSxS\Temp\*" >nul 2>&1
for /d %%i in ("C:\Windows\WinSxS\Temp\*") do rd /s /q "%%i" >nul 2>&1

:: Recycle bin
echo RECYCLE BIN:
rd /s /q "C:\$Recycle.Bin" >nul 2>&1

:: Restart services
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
net start cryptsvc >nul 2>&1

echo.
echo CLEANING COMPLETE.
echo.
pause
