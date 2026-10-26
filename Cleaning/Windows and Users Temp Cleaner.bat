@echo off
title TEMP CLEANER
color 0A

echo Cleaning TEMP folders...
echo.

:: Stop services that may lock temp files
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1

echo USER TEMP (%TEMP%):
del /f /s /q "%TEMP%\*" >nul 2>&1
for /d %%i in ("%TEMP%\*") do rd /s /q "%%i" >nul 2>&1

echo WINDOWS TEMP (C:\Windows\Temp):
del /f /s /q "C:\Windows\Temp\*" >nul 2>&1
for /d %%i in ("C:\Windows\Temp\*") do rd /s /q "%%i" >nul 2>&1

echo ALL USERS TEMP (C:\Users\*\AppData\Local\Temp):
for /d %%u in ("C:\Users\*") do (
    if exist "%%u\AppData\Local\Temp" (
        echo Cleaning: %%u\AppData\Local\Temp
        del /f /s /q "%%u\AppData\Local\Temp\*" >nul 2>&1
        for /d %%i in ("%%u\AppData\Local\Temp\*") do rd /s /q "%%i" >nul 2>&1
    )
)

:: Restart services
net start wuauserv >nul 2>&1
net start bits >nul 2>&1

echo.
echo TEMP CLEANING COMPLETE.
echo.
pause
