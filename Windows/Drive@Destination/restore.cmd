@echo off

if not exist "%~dp0config\targets.txt" (
	echo File^ targets.txt^ not^ found!
	pause
	exit
)

if "%1"=="--sync" (
    set options=/S /PURGE /R:3
) else (
    set options=/S /R:3
)
set exclude=/XF *.DAT* *ntuser* desktop.ini

for /F "usebackq tokens=*" %%V in ( `type "%~dp0config\targets.txt" ^| findstr /V "^#"` ) do ( robocopy "%~dp0%computername%\%username%\%%V" "%userprofile%\%%V" %options% %exclude% )
pause
