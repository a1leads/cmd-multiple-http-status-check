:: Name: Site Network Check
:: Purpose: Check sites status and IP diversity.
:: Author: A1 Lead Generation

@echo off
:ask
echo Would you like to add a URL to the domains list?(Y/N)
set INPUT=
set /P INPUT=Type input: %=%
If /I "%INPUT%"=="y" goto yes 
If /I "%INPUT%"=="n" goto no
pause
:yes
cls
echo Please give me the URL with no http://.
set /p textfileContents= 
echo %textfileContents% >> domains.txt
cls
echo The domains list has been updated and is in the same directory as this batch file.
echo Would you like to add another URL?(Y/N)
set INPUT=
set /P INPUT=Type input: %=%
If /I "%INPUT%"=="y" goto yes 
If /I "%INPUT%"=="n" goto no
pause
goto no
:no
cls
setlocal enabledelayedexpansion
set OUTPUT_FILE=SNC_Results_%date:~-4,4%%date:~-7,2%%date:~-10,2%.csv
>nul copy nul %OUTPUT_FILE%
echo URL,IP Address,HTTP Status,Site Status > %OUTPUT_FILE%
for /f %%i in (domains.txt) do (
    set SERVER_ADDRESS=ADDRESS N/A
    for /f "tokens=1,2,3 delims=" %%a in ('curl -I -s -L %%i ^| findstr /R "HTTP/1.1"') do set STATUS_CODE=%%a
    for /f "tokens=1,2,3" %%x in ('ping -n 1 %%i ^&^& echo SERVER_IS_UP') do (
        if %%x==Pinging set SERVER_ADDRESS=%%y
        if %%x==Reply set SERVER_ADDRESS=%%z
        if %%x==SERVER_IS_UP (set SERVER_STATE=UP) else (set SERVER_STATE=DOWN)
    )
    echo %%i, !SERVER_ADDRESS::=!, !SERVER_STATE!, !STATUS_CODE! >>%OUTPUT_FILE%
)
echo The process is complete. Have a nice day! :)
pause


