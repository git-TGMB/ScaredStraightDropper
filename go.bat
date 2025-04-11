@echo off
setlocal enabledelayedexpansion

REM Get currently logged-in user name
for /f "tokens=1,2*" %%a in ('query user ^| findstr /i "active"') do (
    set SESSION_USER=%%a
)

REM Debug
echo Detected logged-in user: %SESSION_USER%

REM Create temporary scheduled task
schtasks /create /tn RunCPLasUser /tr "rundll32.exe shell32.dll,Control_RunDLL C:\Users\%SESSION_USER%\Temp\SecurityAddOn.cpl" /sc once /st 00:00 /ru %SESSION_USER% /rl HIGHEST

REM Run it
schtasks /run /tn RunCPLasUser

REM Optional cleanup
timeout /t 3 >nul
schtasks /delete /tn RunCPLasUser /f
