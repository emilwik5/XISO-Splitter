@echo off
title Xbox ISO Splitter
color 0A

if not "%~1"=="" set "f=%~1" & goto run

echo ===========================================================
echo                       XISO SPLITTER 
echo ===========================================================
echo This tool splits large XISO files into 3.5GB parts for use
echo on OG Xbox FATX drives 
echo.
echo HOW TO USE:
echo  1. Drag and drop your ISO file onto this window
echo     OR
echo  2. Type or paste the full path to your XISO and press Enter.
echo ===========================================================
echo.
set /p "f=ISO file path: "

:run
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0SplitXISO.ps1" "%f%"

