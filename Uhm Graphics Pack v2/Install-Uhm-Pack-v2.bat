@echo off
:: =====================================================================
::
::   Install-Uhm-Pack-v2.bat
::   ------------------------
::   Uhm Graphics Pack v2 - Setup Launcher
::
::   Launches the interactive installer for the Uhm Graphics Pack
::   (Assetto Corsa / CSP / Pure). Performs a privilege check,
::   self-elevates through UAC when required, validates that all
::   package components are present and hands over control to the
::   PowerShell installer engine.
::
::   Usage     :  Double-click, or run from a command prompt.
::   Requires  :  Windows 10/11, Windows PowerShell 5.1+
::   Author    :  Uhm
::   Version   :  2.0
::
::   Exit codes:
::     0  Success
::     1  Package integrity check failed (missing files)
::     2  Installer engine terminated with an error
::     3  Prerequisite missing (PowerShell not available)
::
:: =====================================================================

setlocal EnableExtensions DisableDelayedExpansion
title Uhm Graphics Pack v2 - Setup
cd /d "%~dp0"

:: Use UTF-8 console output
>nul chcp 65001

echo.
echo  ================================================================
echo                Uhm Graphics Pack v2  -  Setup
echo  ================================================================
echo.

:: ---------------------------------------------------------------------
:: 1. Administrative privileges (required to write into the game folder
::    when it is located under Program Files)
:: ---------------------------------------------------------------------
:check_privileges
>nul 2>&1 net session
if %errorlevel% equ 0 goto got_privileges

echo  [*] Administrative privileges are required.
echo  [*] Requesting elevation through UAC...
echo.

:: Re-launch this script elevated via a temporary VBScript helper.
set "batchPath=%~f0"
> "%temp%\uhm_pack_v2_elevate.vbs" echo Set UAC = CreateObject^("Shell.Application"^)
>> "%temp%\uhm_pack_v2_elevate.vbs" echo UAC.ShellExecute "%batchPath%", "ELEV", "", "runas", 1
cscript //nologo "%temp%\uhm_pack_v2_elevate.vbs"
del /f /q "%temp%\uhm_pack_v2_elevate.vbs" >nul 2>&1
exit /b

:got_privileges
:: Drop the ELEV marker if present and restore the working directory.
if "%~1"=="ELEV" shift /1
cd /d "%~dp0"

:: ---------------------------------------------------------------------
:: 2. Prerequisite checks
:: ---------------------------------------------------------------------
echo  [1/3] Checking prerequisites...

where powershell.exe >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo  [ERROR] Windows PowerShell was not found on this system.
    echo          The installer cannot continue.
    goto fatal_prerequisite
)

if not exist "%~dp0Installer\installer.ps1" (
    echo.
    echo  [ERROR] Installer engine not found:
    echo          %~dp0Installer\installer.ps1
    echo.
    echo          Make sure the complete pack folder was downloaded
    echo          and this file was not moved out of it.
    goto fatal_integrity
)

if not exist "%~dp02-PPFilter" (
    echo.
    echo  [ERROR] Package data folders are missing.
    echo          The download appears to be incomplete.
    goto fatal_integrity
)

echo         PowerShell ...... OK
echo         Installer engine  OK
echo         Package data .... OK
echo.

:: ---------------------------------------------------------------------
:: 3. Launch the installer engine (PowerShell)
:: ---------------------------------------------------------------------
echo  [2/3] Starting the installer...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Installer\installer.ps1"
set "installerResult=%errorlevel%"

echo.
if not "%installerResult%"=="0" (
    echo  [3/3] Finished with errors. Code: %installerResult%
    echo        Review the messages above, then try again.
    goto fatal_engine
)

echo  [3/3] Setup completed successfully.
echo.
echo  ================================================================
echo   Thank you for installing Uhm Graphics Pack v2.
echo   Full instructions: see the README file in this folder.
echo  ================================================================
echo.
endlocal
exit /b 0

:: ---------------------------------------------------------------------
:: Error handlers
:: ---------------------------------------------------------------------
:fatal_integrity
echo.
echo  Setup cannot continue. Press any key to exit.
pause >nul
endlocal & exit /b 1

:fatal_engine
echo.
echo  Press any key to exit.
pause >nul
endlocal & exit /b 2

:fatal_prerequisite
echo.
echo  Press any key to exit.
pause >nul
endlocal & exit /b 3
