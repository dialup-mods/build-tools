@echo off
setlocal enabledelayedexpansion

set RUNS=3

echo Cleaning...
make clean >nul 2>&1

set TOTAL=0

for /L %%i in (1,1,%RUNS%) do (
    echo.
    echo Run %%i/%RUNS%...
    
    set START=!TIME!
    make configure game=rocketleague
    make build
    set END=!TIME!
    
    call :TimeDiff !START! !END!
    echo   Time: !DIFF!s
    
    if %%i LSS %RUNS% (
        make clean >nul 2>&1
    )
)

echo.
echo =========================================
echo Done
echo =========================================
goto :eof

:TimeDiff
set start=%1
set end=%2
for /F "tokens=1-4 delims=:.," %%a in ("%start%") do (
   set /A "start_s=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)"
   set /A "start_ms=1%%d %% 1000"
)
for /F "tokens=1-4 delims=:.," %%a in ("%end%") do (
   set /A "end_s=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)"
   set /A "end_ms=1%%d %% 1000"
)
set /A "diff_s=end_s-start_s"
set /A "diff_ms=end_ms-start_ms"
if %diff_ms% LSS 0 (
    set /A "diff_s-=1"
    set /A "diff_ms+=1000"
)
set DIFF=%diff_s%.%diff_ms%
goto :eof
