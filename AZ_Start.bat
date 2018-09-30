@echo off
TITLE DayZ SA Server - Status
COLOR 0A
mode con:cols=60 lines=2
:: Variables::
::SteamCMD.exe path
set STEAM_CMD_LOCATION="C:\SteamCMD"
set STEAM_USERNAME="anonymous"
::DayZServer_64.exe path
set DAYZ-SA_SERVER_LOCATION="C:\DayZ-SA_server"
::Bec.exe path
set BEC_LOCATION="C:\DayZ-SA_server\Bec"
::IMPORTANT: Modify line 70 to your correct parameters
::::::::::::::

echo Agusanz
goto checksv
pause

:checksv
tasklist /FI "IMAGENAME eq DayZServer_x64.exe" 2>NUL | find /I /N "DayZServer_x64.exe">NUL
if "%ERRORLEVEL%"=="0" goto checkbec
cls
echo Server is not running, taking care of it..
goto killsv

:checkbec
tasklist /FI "IMAGENAME eq Bec.exe" 2>NUL | find /I /N "Bec.exe">NUL
if "%ERRORLEVEL%"=="0" goto loopsv
cls
echo Bec is not running, taking care of it..
goto startbec

:loopsv
FOR /L %%s IN (30,-1,0) DO (
	cls
	echo Server is running. Checking again in %%s seconds.. 
	timeout 1 >nul
)
goto checksv

:killsv
taskkill /f /im Bec.exe
taskkill /f /im DayZServer_x64.exe
goto updatesv

:updatesv
cls
echo Updating DayZ SA Server.
timeout 1 >nul
cls
echo Updating DayZ SA Server..
timeout 1 >nul
cls
echo Updating DayZ SA Server...
cd "%STEAM_CMD_LOCATION%"
start /wait "" steamcmd.exe +login "%STEAM_USERNAME%" +force_install_dir %~dp0 +app_update 223350 validate +quit
goto startsv

:startsv
cls
echo Starting DayZ SA Server.
timeout 1 >nul
cls
echo Starting DayZ SA Server..
timeout 1 >nul
cls
echo Starting DayZ SA Server...
cd "%DAYZ-SA_SERVER_LOCATION%"
start DayZServer_x64.exe -config=serverDZ.cfg -port=2302 -profiles=C:\Users\%USER%\Documents\DayZ -dologs -adminlog -netlog -freezecheck -noFilePatching -BEpath=C:\DayZ-SA_server\battleye
FOR /L %%s IN (30,-1,0) DO (
	cls
	echo Initializing server, wait %%s seconds to initialize Bec.. 
	timeout 1 >nul
)
goto startbec

:startbec
cls
echo Starting Bec.
timeout 1 >nul
cls
echo Starting Bec..
timeout 1 >nul
cls
echo Starting Bec...
timeout 1 >nul
cd "%BEC_LOCATION%"
start Bec.exe -f Config.cfg --dsc
goto checksv
