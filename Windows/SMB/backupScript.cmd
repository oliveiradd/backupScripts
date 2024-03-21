@echo off

if not exist "%~dp0config\config.txt" (
	echo File^ config.txt^ not^ found!
	pause
	exit
)
for /F "usebackq tokens=*" %%V in ( `type "%~dp0config\config.txt" ^| findstr /V "^#"` ) do ( set "%%V" )

set "destination=\\%server_ip%\%server_share%"

if not exist "%destination%" ( 
	echo Error:^ network^ share^ not^ available.
	exit
)

if not exist "%~dp0config\targets.txt" (
	echo File^ targets.txt^ not^ found!
	pause
	exit
)

if "%1"=="--add" (
    options=/XO /XF *.DAT* *ntuser* desktop.ini
) else (
    options=/XO /PURGE /XF *.DAT* *ntuser* desktop.ini
)

for /F "usebackq tokens=*" %%V in ( `type "%~dp0config\targets.txt" ^| findstr /V "^#"` ) do ( robocopy "%userprofile%\%%V" "%destination%\%computername%\%username%\%%V" %options% )
pause
