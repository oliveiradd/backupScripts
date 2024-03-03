(robocopy "%userprofile%" "%~dp0%username%" /s /purge /r:3 /w:0 /z /it /xa:H /xd "%userprofile%\AppData" "%userprofile%\Application Data"
msg * /server:%computername% "Backup concluído. Você já pode ejetar e desconectar seu HD externo.") || msg * /server:%computername% "Ocorreu um erro na transferência dos arquivos. Verifique se não há mal contato e tente novamente."
