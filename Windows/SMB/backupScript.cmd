@echo off

set server=10.8.0.1
set remote_share=%username%

set source=%userprofile%
set destination=\\%server%\%remote_share%
set options=/E /R:3 /W:5 /XA:H /XJD /XD AppData Contacts Downloads Favorites IntelGraphicsProfiles Links Onedrive Nextcloud Searches /XF *.DAT* *ntuser* desktop.ini

if not exist %destination% ( 
	msg "%username%" "Error. Network share not available."
	exit
)

if not exist %destination%\%computername%\%username% ( 
	mkdir %destination%\%computername%\%username%
)

if %1==--add (
    robocopy "%source%" "%destination%" %options% /XO
) else if %1==--sync (
    robocopy "%source%" "%destination%" %options% /XO /PURGE
) else if %1==--pull (
    robocopy "%destination%" "%source%" %options% /XO
) else if %1==--restore (
    robocopy "%destination%" "%source%" %options%
) else (
    echo "Option not recognized."
)
