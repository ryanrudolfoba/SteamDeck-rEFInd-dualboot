@echo off
rem - create 1rEFInd-tools folder and copy the powershell script
mkdir C:\1rEFInd-tools
copy "%~dp0custom\rEFIndTask.ps1" c:\1rEFInd-tools
cls
echo rEFInd Windows Install Script by ryanrudolf
echo https://github.com/ryanrudolfoba/SteamDeck-rEFInd-dualboot

rem - delete existing task and then create it
schtasks /delete /tn rEFIndTask-donotdelete /f
schtasks /create /tn rEFIndTask-donotdelete /xml "%~dp0custom\rEFIndTask.xml"

if %errorlevel% equ 0 goto :success
if %errorlevel% neq 0 goto :accessdenied
:accessdenied
echo Make sure you right-click the rEFIndWindows.bat and select RUNAS ADMIN!
pause
goto :end

:success
echo Scheduled Task has been created!
echo.
echo 1. Go to Windows Administrative Tools, then Scheduled Task.
echo 2. Right-click the task called rEFIndTask, then select Properties.
echo 3. Under the General Tab, change the option to RUN WHETHER USER IS LOGGED IN OR NOT.
echo 4. Put a check mark on DO NOT STORE PASSWORD.
echo 5. Press OK. Right click the task and select RUN.
echo 6. Go to C:\1rEFInd-tools and look for a file called status.txt
echo 7. Open the file and compare the rEFInd GUID and bootsequence they should be the same!
echo 8. Windows configuration is done!
pause

:end
