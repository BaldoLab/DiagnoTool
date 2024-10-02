@echo off
:: Controllo privilegi amministratore
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Richiesta l'elevazione a amministratore...
    powershell start-process "%~0" -verb runas
    exit /b
)

:: Comandi con privilegi di amministratore
echo Il prompt dei comandi e' in esecuzione come amministratore.
pause

@echo off
setlocal enabledelayedexpansion
:menu
cls
echo ================================================================
echo Sistema di diagnostica avanzato by Baldo
echo ATTENZIONE: UTILIZZARE SOLO SE UTENTI ESPERTI!!!
echo ================================================================
echo Tool disponibili:
echo ================================================================
echo 1. Informazioni sul sistema
echo 2. Controlla lo stato della connessione di rete
echo 3. Apri Gestione Attivita
echo 4. Apri Visualizzatore Eventi
echo 5. Report Batteria
echo 6. Monitor Prestazioni Real Time
echo 7. Monitoraggio affidabilita
echo 8. Diagnostica Grafica e Audio 
echo 9. Diagnostica RAM
echo 10. Controlla e ripara file corrotti
echo 11. Pulizia disco
echo 12. Cambio DNS
echo 13. Rimozione forzata malware (mrt)
echo 14. Debloating tool
echo 15. Formattazione Supporto Dati
echo 16. Esci
echo ================================================================
set /p choice="Inserisci il numero della tua scelta (1-15): "

if "%choice%"=="1" goto info
if "%choice%"=="2" goto check_network
if "%choice%"=="3" goto task
if "%choice%"=="4" goto event
if "%choice%"=="5" goto battery
if "%choice%"=="6" goto performance
if "%choice%"=="7" goto aff
if "%choice%"=="8" goto fx
if "%choice%"=="9" goto mem
if "%choice%"=="10" goto corrupt
if "%choice%"=="11" goto clean_disk
if "%choice%"=="12" goto dns
if "%choice%"=="13" goto malware
if "%choice%"=="14" goto debloat
if "%choice%"=="15" goto erase
if "%choice%"=="16" goto end

echo Scelta non valida! Riprova.
pause
goto menu

:check_network
cls
echo Stato della connessione di rete:
ipconfig
pause
goto menu

:battery
cls
echo Report Batteria:
powercfg /batteryreport
pause
goto menu

:event
cls
echo Event Viewer:
eventvwr
pause
goto menu

:debloat
cls
echo Debloating Tool:
echo Esecuzione in powershell
powershell -Command "iwr -useb https://christitus.com/win | iex"
echo Esecuzione tool terminata
pause
goto menu

:performance
cls
echo Perfomance Monitor (Prestazioni Real Time):
perfmon
pause
goto menu

:info
cls
systeminfo
pause
goto menu

:task
cls
echo Gestione attivita:
taskmgr
pause
goto menu

:aff
cls
echo Monitoraggio affidabilita:
perfmon /rel
pause 
goto menu

:mem
cls
echo Diagnostica RAM:
mdsched
pause
goto menu

:corrupt
cls
echo Controlla e ripara file corrotti:
sfc /scannow
pause
goto menu

:fx
cls
echo DIagnostica Grafica e Audio
dxdiag
pause
goto menu

:clean_disk
cls
echo Pulizia disco:
cleanmgr
pause
goto menu

:dns
cls
echo Avvio tool cambio dns
echo Elenco Interfacce
netsh interface show interface

echo Indirizzi DNS (Primario - Secondario)
echo 1. DNS Google Standard (8.8.8.8 - 8.8.4.4)
echo 2. AdGuard DNS No Crypt (94.140.15.15 - Null)
echo 3. AdGuard DNS Crypt (94.140.14.14 - Null)
echo 4. OpenDns (208.67.222.222 - 208.67.220.220)

set /p interfaccia="Inserisci il nome dell'interfaccia di rete: "
set /p dns_primario="Inserisci l'indirizzo DNS primario: "
set /p dns_secondario="Inserisci l'indirizzo DNS secondario (lascia vuoto se non necessario): "

echo.
echo Cambiando il DNS per l'interfaccia "%interfaccia%"...
if not "%dns_secondario%"=="" (
    echo DNS Primario: %dns_primario%
    echo DNS Secondario: %dns_secondario%
    netsh interface ipv4 set dns name="%interfaccia%" static %dns_primario% primary
    netsh interface ipv4 add dns name="%interfaccia%" %dns_secondario% index=2
) else (
    echo DNS Primario: %dns_primario%
    netsh interface ipv4 set dns name="%interfaccia%" static %dns_primario%
)

if %errorlevel% equ 0 (
    echo DNS cambiato con successo.
) else (
    echo Si è verificato un errore durante il cambio del DNS.
    echo Assicurati di eseguire lo script come amministratore e che il nome dell'interfaccia sia corretto.
)

ipconfig /flushdns

echo.
pause
goto menu

:malware
cls
echo Rimozione Forzata Malware
mrt
pause
goto menu

:erase
cls
echo Avvio utilita di formattazione
echo Formattare disco:
echo Passo 1. list disk
echo Passo 2. select disk X 
echo Passo 3. clean
echo Creare una partizione:
echo Passo 1. create partition primary
echo Passo 2. format fs=ntfs quick
echo Per uscire: exit
diskpart
pause
goto menu

:end
echo Uscita dal programma...
pause
exit