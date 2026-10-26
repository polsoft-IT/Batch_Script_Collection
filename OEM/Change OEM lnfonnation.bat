@echo off
:: ==========================================================
::  Change OEM Information Module
::  Author: Sebastian (framework-ready, bilingual EN/PL)
::  Purpose: Update OEM info in Windows registry
:: ==========================================================

:: --- Bilingual header (EN/PL) ---
echo ============================================
echo   CHANGE OEM INFORMATION / ZMIANA DANYCH OEM
echo ============================================

:: --- Ask for values ---
set /p OEMManufacturer=Enter Manufacturer (Producent): 
set /p OEMModel=Enter Model (Model): 
set /p OEMSupportPhone=Enter Support Phone (Telefon wsparcia): 
set /p OEMSupportURL=Enter Support URL (Adres WWW): 
set /p OEMLogoPath=Enter Logo Path (Ścieżka do logo BMP): 

:: --- Registry path ---
set RegPath=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation

:: --- Apply changes ---
echo Updating OEM Information...
reg add "%RegPath%" /v Manufacturer /t REG_SZ /d "%OEMManufacturer%" /f
reg add "%RegPath%" /v Model /t REG_SZ /d "%OEMModel%" /f
reg add "%RegPath%" /v SupportPhone /t REG_SZ /d "%OEMSupportPhone%" /f
reg add "%RegPath%" /v SupportURL /t REG_SZ /d "%OEMSupportURL%" /f

:: --- Logo (must be BMP format) ---
if not "%OEMLogoPath%"=="" (
    reg add "%RegPath%" /v Logo /t REG_SZ /d "%OEMLogoPath%" /f
)

echo.
echo OEM Information updated successfully!
echo (Restart may be required to see changes)
pause