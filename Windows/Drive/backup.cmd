@echo off

if not exist "%~dp0config\config.txt" (
	echo File^ config.txt^ not^ found!
	pause
	exit
)
for /F "usebackq tokens=*" %%V in ( `type "%~dp0config\config.txt" ^| findstr /V "^#"` ) do ( set "%%V" )

set "destination=%drive_letter%"

if not exist "%destination%" ( 
	echo Error:^ drive^ not^ available.
	exit
)

if not exist "%~dp0config\targets.txt" (
	echo File^ targets.txt^ not^ found!
	pause
	exit
)

if "%1"=="--add" (
    set options=/S /XO /R:3
) else (
    set options=/S /XO /PURGE /R:3
)
set exclude=/XF *.DAT* *ntuser* desktop.ini

for /F "usebackq tokens=*" %%V in ( `type "%~dp0config\targets.txt" ^| findstr /V "^#"` ) do ( robocopy "%userprofile%\%%V" "%destination%\%computername%\%username%\%%V" %options% %exclude% )
pause
