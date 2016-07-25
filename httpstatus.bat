:: Name: HTTP Status Request
:: Purpose: Retrieve HTTP Status For Multiple Domains
:: Author: A1 Lead Generation

@echo off
    title HTTP Status Request
    setlocal enableextensions disabledelayedexpansion

    > testResults_%date:~-4,4%%date:~-7,2%%date:~-10,2%.txt (
        for /f "useback delims=" %%u in ("domains.txt") do (
            set "statusCode="
            echo([%%u]
            for /f "tokens=1,2 delims=#" %%a in ('
                curl -w "##%%{time_connect}##." -I -s --url "%%~u"
                ^| findstr /l /b /c:"HTTP/" /c:"##"
            ') do if "%%b"=="." (
                setlocal enabledelayedexpansion
                echo(    !statusCode! - %%a
                endlocal
            ) else (
                set "statusCode=%%a"
            )
        )
    )
    echo Ths process is complete.
    pause