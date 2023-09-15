@echo off

set source=%userprofile%
set destination=%userprofile%\Nextcloud\%computername%\%username%
set options=/E /R:3 /W:5 /XA:H /XJD /XD AppData Contacts Downloads Favorites IntelGraphicsProfiles Links Onedrive Nextcloud Searches /XF *.DAT* *ntuser* desktop.ini

if not exist %userprofile%\Nextcloud\%computername%\%username% ( 
    mkdir %userprofile%\Nextcloud\%computername%\%username%
)

if %1==--add (
    robocopy %source%\ %destination%\ %options% /XO
) else if %1==--sync (
    robocopy %source%\ %destination%\ %options% /XO /PURGE
) else if %1==--pull (
    robocopy %destination%\ %source%\ %options% /XO /PURGE
) else if %1==--restore (
    robocopy %destination%\ %source%\ %options% /PURGE
) else (
    echo "Option not recognized."
)
