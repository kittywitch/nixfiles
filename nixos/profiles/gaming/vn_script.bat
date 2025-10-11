@echo off
set VN_DIR=%1
set VN_EXE=%2
set VN_ARCH=%3

echo "Setting UTF-8..."
chcp 65001 > nul

echo "Launching VN..."
cd /d %VN_DIR%
start %VN_EXE%

echo Launching Textractor...
cd /d "C:\users\steamuser\Desktop\Textractor\%VN_ARCH%"
start Textractor.exe

exit
