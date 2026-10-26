@echo off
:: Włączenie obsługi ANSI w Windows 10/11
for /f "tokens=2 delims=: " %%a in ('reg query HKCU\Console /v VirtualTerminalLevel 2^>nul') do set vt=%%a
if not defined vt (
    reg add HKCU\Console /f /v VirtualTerminalLevel /t REG_DWORD /d 1 >nul
)

set "R=[38;5;196m"
set "Y=[38;5;226m"
set "G=[38;5;34m"
set "B=[38;5;21m"
set "N=[0m"

echo(
echo      %R%████████████  %Y%████████████%N%               %R%██ %Y%██%N%
echo      %R%████████████  %Y%████████████%N%               %R%██ %Y%██%N%
echo      %R%████████████  %Y%████████████%N%               %R%██ %Y%██%N%
echo      %R%████████████  %Y%████████████%N%               %R%██ %Y%██%N%
echo(
echo      %G%████████████  %B%████████████%N%               %G%██ %B%██%N%
echo      %G%████████████  %B%████████████%N%               %G%██ %B%██%N%
echo      %G%████████████  %B%████████████%N%               %G%██ %B%██%N%
echo      %G%████████████  %B%████████████%N%               %G%██ %B%██%N%
echo(

pause
