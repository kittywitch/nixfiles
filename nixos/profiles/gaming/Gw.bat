@echo on
set GW_DIR=%1
set GW_EXE=Gw.exe
set GWT_EXE=GWToolbox.exe

echo "Setting UTF-8..."
chcp 65001 > nul

echo "Launching GW1..."
cd /d %GW_DIR%
start /b %GW_EXE%

timeout /t 5 /nobreak > NUL

echo "Launching toolbox..."
start /b %GWT_EXE%

exit
