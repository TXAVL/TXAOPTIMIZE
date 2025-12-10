@echo off
setlocal

:: --- THIET LAP MAU CHO MÀN HÌNH ---
:: Reset màu (default)
color 07

echo Dang tat Battery Percentage...
vivetool.exe /reset /id:56328729,48433719 2>nul
if errorlevel 1 (
    color 0C
    echo ERROR: Khong the tat. Co the do build Windows hoac ID da thay doi.
) else (
    color 0A
    echo SUCCESS: Da tat. Hay khoi dong lai may de ap dung.
)
