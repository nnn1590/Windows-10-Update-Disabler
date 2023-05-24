rem This script was written by Tarik Seyceri - Published in 2020
rem email: tarik@seyceri.info
cls

@echo off

echo.
echo Welcome to Windows 10 Update Disabler
echo.

rem Check If User Has Admin Privileges
timeout /t 1 /nobreak > NUL
openfiles > NUL 2>&1
if %errorlevel%==0 (
    echo Running..
) else (
    echo You must run me as an Administrator. Exiting..
    echo.
    echo Right-click on me and select ^'Run as Administrator^' and try again.
    echo.
    echo Press any key to exit..
    pause > NUL
    exit
)

echo.

rem Disable Update Services and Their Helpers
sc config wuauserv start= disabled
sc failure wuauserv reset= 0 actions= ""
net stop wuauserv

sc config bits start= disabled
sc failure bits reset= 0 actions= ""
net stop bits

sc config dosvc start= disabled
sc failure dosvc reset= 0 actions= ""
net stop dosvc

rem Adding Update Prevention Registry Keys
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v AUOptions /d 2 /t REG_DWORD /f
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v AutoInstallMinorUpdates /d 0 /t REG_DWORD /f
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v NoAutoUpdate /d 1 /t REG_DWORD /f
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v NoAutoRebootWithLoggedOnUsers /d 1 /t REG_DWORD /f

rem Disable Update Task Schedules
SCHTASKS /Change /TN "\Microsoft\Windows\WindowsUpdate\Automatic App Update" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\WindowsUpdate\sih" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\WindowsUpdate\sihboot" /DISABLE

SCHTASKS /Change /TN "\Microsoft\Windows\UpdateOrchestrator\UpdateAssistant" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\UpdateOrchestrator\UpdateAssistantCalendarRun" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\UpdateOrchestrator\UpdateAssistantWakeupRun" /DISABLE

rem Delete Some Update Files
del /s /f /q %WinDir%\SoftwareDistribution\Download\*.*

echo.
echo Windows 10 Update Disabled.
echo.

pause > NUL
exit
