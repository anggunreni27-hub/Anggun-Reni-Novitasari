@echo off
title Logout / Hapus Kredensial GitHub - Komputer Lab
color 0C
cd /d "%~dp0"

echo ======================================================
echo          LOGOUT / BERSIHKAN AKUN GITHUB
echo          Untuk Komputer Bersama / Lab
echo ======================================================
echo.
echo Script ini akan menghapus sesi login GitHub dari Git
echo dan Windows Credential Manager di komputer ini.
echo.
set /p CONFIRM="Yakin ingin logout/hapus kredensial GitHub sekarang? (Y/T): "
if /i not "%CONFIRM%"=="Y" (
    echo Proses dibatalkan.
    pause
    exit /b
)

echo.
echo [1/3] Menghapus kredensial Git credential manager...
echo url=https://github.com | git credential reject >nul 2>&1

echo [2/3] Menghapus akun GitHub dari Windows Credential Manager...
cmdkey /delete:LegacyGeneric:target=git:https://github.com >nul 2>&1
cmdkey /delete:git:https://github.com >nul 2>&1

echo [3/3] Menghapus identitas git config global (user.name & user.email)...
git config --global --unset user.name >nul 2>&1
git config --global --unset user.email >nul 2>&1

echo.
echo ======================================================
echo   BERHASIL LOGOUT DARI GIT / WINDOWS!
echo ======================================================
echo.
echo PENTING (Khusus Browser):
echo Jika Anda juga sempat login di Google Chrome / Edge:
echo  1. Buka browser Anda.
echo  2. Buka https://github.com
echo  3. Klik foto profil di pojok kanan atas, lalu klik 'Sign out'.
echo.
pause
