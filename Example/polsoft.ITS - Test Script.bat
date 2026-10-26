@echo off
:: ============================================
:: Sample test script
:: Author: polsoft.ITS™
:: Date: 2026-01-27
:: Description: Demonstration of dbbatch capabilities
:: ============================================

setlocal EnableDelayedExpansion

:: Configuration
set "SCRIPT_NAME=test_script"
set "VERSION=1.0.0"

:: Welcome message
echo ================================================
echo            polsoft.ITS - Test Script
echo ================================================
echo.

:: System information
echo [INFO] Version: %VERSION%
echo [INFO] Date: %DATE% %TIME%
echo [INFO] System: %OS%
echo.

:: Directory check
echo [CHECK] Checking directories...
if exist "C:\Windows" (
    echo [OK] Windows directory exists
) else (
    echo [ERROR] Windows directory missing
)

:: Environment variables
echo.
echo [INFO] Environment variables:
echo - USERNAME: %USERNAME%
echo - COMPUTERNAME: %COMPUTERNAME%
echo - PATH defined: OK

:: Loop test
echo.
echo [PROCESS] FOR loop test:
for /L %%i in (1,1,5) do (
    echo    Iteration %%i
)

:: Completion
echo.
echo ================================================
echo [SUCCESS] Script completed successfully
echo ================================================
pause

endlocal
exit /b 0