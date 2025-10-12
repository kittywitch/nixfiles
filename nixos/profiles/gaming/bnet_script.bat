@echo on
set BNET_DIR=%1
set BNET_EXE=%~2
set GAME=%3

echo "Setting UTF-8..."
chcp 65001 > nul

echo "Launching Battle.net..."
cd /d %BNET_DIR%
start /b %BNET_EXE% --in-process-gpu

timeout /t 60 /nobreak > NUL

echo "Launching game within Battle.net..."
start /b %BNET_EXE% --exec="launch %GAME%"
exit
