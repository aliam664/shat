@echo off
rem ================================================================
rem  Uhm Graphics Pack v2 - نصب خودکار (دابل کلیک کنید)
rem  Auto installer - asks for the game folder with a file-explorer
rem  style dialog, detects versions, installs and fixes problems.
rem ================================================================
cd /d "%~dp0"
chcp 65001 >nul
title Uhm Graphics Pack v2 - Installer

rem --- elevate to admin so it can write into Program Files ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo در حال درخواست دسترسی مدیر برای نصب...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Installer\installer.ps1"
if %errorLevel% neq 0 (
    echo.
    echo مشکلی پیش آمد. گزارش خطا بالا را بخوانید و یک کلید بزنید.
    pause >nul
)
