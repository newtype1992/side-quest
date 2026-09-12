@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\Build.ps1" -Action Run
if errorlevel 1 pause
